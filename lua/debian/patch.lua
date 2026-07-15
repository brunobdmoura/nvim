-- Converts/refreshes the header of a dep3patch buffer.
--
-- Turns a `git format-patch` style header:
--   From: Name <email>
--   Date: <date>
--   Subject: Subject line
--
--   optional long description body
--   ---
--    diffstat...
--
-- into a DEP-3 style header:
--   Description: Subject line
--    long description body, one paragraph per line, blank lines
--    represented by `empty_line_char`
--   Author: Name <email>
--   Forwarded: not-needed
--   Last-Update: <date>
--   ---
--    diffstat...
--
-- Re-running it on an already-converted (DEP-3) buffer only refreshes the
-- `Last-Update` field, preserving Description/Author/Forwarded as edited by
-- the user.
local M = {}

--- Runs `cmd` in `cwd` via the shell and returns its stdout split into lines.
---@param cwd string: directory to run the command in
---@param cmd string: shell command to execute
---@return table: list of output lines
local function run(cwd, cmd)
  return vim.fn.systemlist(string.format("cd %s && %s", vim.fn.shellescape(cwd), cmd))
end

--- Returns the abbreviated sha of the commit currently paused on by an
--- in-progress `git rebase` (interactive or am-based), or `nil` if `cwd`
--- is not a git repository or no rebase is in progress.
---@param cwd string: git repository (or subdirectory) to inspect
---@return string|nil: commit-ish of the rebase's current commit
local function rebase_current_commit(cwd)
  local merge_dir = run(cwd, "git rev-parse --git-path rebase-merge")[1]
  local apply_dir = run(cwd, "git rev-parse --git-path rebase-apply")[1]

  local candidates = {}
  if merge_dir and vim.fn.isdirectory(merge_dir) == 1 then
    table.insert(candidates, merge_dir .. "/stopped-sha")
  end
  if apply_dir and vim.fn.isdirectory(apply_dir) == 1 then
    table.insert(candidates, apply_dir .. "/original-commit")
  end

  for _, file in ipairs(candidates) do
    if vim.fn.filereadable(file) == 1 then
      local sha = vim.trim(vim.fn.readfile(file)[1] or "")
      if sha ~= "" then
        return sha
      end
    end
  end
  return nil
end

--- Computes the value to use for the `Last-Update` field: the author date
--- of the commit currently being rebased, when `cwd` is a git repository
--- with a rebase in progress; otherwise today's date.
---@param cwd string: git repository (or subdirectory) to inspect
---@return string: date formatted as YYYY-MM-DD
local function last_update_date(cwd)
  local sha = rebase_current_commit(cwd)
  if sha then
    local date = run(cwd, string.format("git log -1 --date=short --format=%%ad %s", sha))[1]
    if date and date ~= "" then
      return date
    end
  end
  return os.date("%Y-%m-%d")
end

--- Finds where the header ends and the actual patch content begins.
--- Handles both `git format-patch` style patches (header ends at a lone
--- `---` line before the diffstat) and quilt/dep3 style patches (header
--- ends right where the diff starts, e.g. at `Index:`, `diff --git`,
--- `--- a/file`/`--- orig/file`, or a hunk header, with no separator).
---@param lines table: all lines of the buffer
---@return number|nil: index of the first line that belongs to the patch
---  content (kept as-is, unparsed), or `nil` if no boundary was found
local function find_header_end(lines)
  for i, line in ipairs(lines) do
    if line:match("^Index:%s")
        or line:match("^diff %-%-git ")
        or line:match("^%-%-%-%s*$")
        or line:match("^%-%-%- ")
        or line:match("^@@ ") then
      return i
    end
  end
  return nil
end

--- Parses a `git format-patch` style header into its `From`/`Subject`
--- fields plus the free-form commit-message body that follows them.
---@param header table: header lines (everything before the `---` separator)
---@return table|nil: `{ author, description }` where `description` is a
---  list of lines (subject first, body lines after), or `nil` if `header`
---  isn't a recognizable git-am style header
local function parse_gitam_header(header)
  local known = { from = true, date = true, subject = true }
  local author, subject
  local body_start = nil

  local key, value
  for i, line in ipairs(header) do
    local k, v = line:match("^(%a[%w-]*):%s?(.*)$")
    if k and known[k:lower()] then
      key, value = k:lower(), v
    elseif line:match("^%s") and key then
      value = value .. " " .. vim.trim(line)
    elseif line == "" then
      body_start = i + 1
      break
    else
      key = nil
    end

    if key == "from" then
      author = value
    elseif key == "subject" then
      subject = value
    end
  end

  if not author or not subject then
    return nil
  end

  -- Strip the "[PATCH ...]" prefix `git format-patch` adds to the subject.
  subject = subject:gsub("^%[PATCH[^%]]*%]%s*", "")

  local description = { subject }
  if body_start then
    for i = body_start, #header do
      table.insert(description, header[i])
    end
    -- Drop a single trailing blank line left over before the `---` line.
    while #description > 1 and description[#description] == "" do
      table.remove(description)
    end
  end

  return { author = author, description = description }
end

--- Parses an already-DEP-3-formatted header, reconstructing the raw
--- (unfolded) `Description` body and pulling out `Author`/`Forwarded`.
---@param header table: header lines (everything before the `---` separator)
---@param empty_line_char string: character used to represent blank lines
---  within a folded field
---@return table|nil: `{ author, description, forwarded }`, or `nil` if
---  `header` has no `Description` field
local function parse_dep3_header(header, empty_line_char)
  local fields, order = {}, {}
  local current

  for _, line in ipairs(header) do
    local key, value = line:match("^(%a[%w-]*):%s?(.*)$")
    if key then
      current = { value }
      fields[key:lower()] = current
      table.insert(order, key:lower())
    elseif current and line:match("^%s") then
      table.insert(current, vim.trim(line))
    end
  end

  local description_field = fields["description"]
  if not description_field then
    return nil
  end

  local description = {}
  for _, line in ipairs(description_field) do
    table.insert(description, line == empty_line_char and "" or line)
  end

  local author_field = fields["author"]
  local forwarded_field = fields["forwarded"]

  return {
    author = author_field and author_field[1] or nil,
    description = description,
    forwarded = forwarded_field and forwarded_field[1] or nil,
  }
end

--- Regenerates the DEP-3 header of the current buffer: converts a
--- `git format-patch` style header into DEP-3 fields (Description, Author,
--- Forwarded, Last-Update), or, if the header is already DEP-3, just
--- refreshes `Last-Update` while preserving the existing
--- Description/Author/Forwarded fields.
---@param spacing number|nil: leading spaces on Description continuation
---  lines (DEP-3 requires exactly 1); defaults to 1
---@param empty_line_char string|nil: character used to represent blank
---  lines within the folded Description field; defaults to "."
---@return nil
function M.refresh(spacing, empty_line_char)
  spacing = spacing or 1
  empty_line_char = empty_line_char or "."
  local indent = string.rep(" ", spacing)

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":h")

  local sep_idx = find_header_end(lines)
  if not sep_idx then
    vim.notify("dep3patch: could not find start of patch content", vim.log.levels.ERROR)
    return
  end

  -- Patches whose diff starts with `Index:`/`diff --git`/a hunk header
  -- (no `---` separator) commonly have a blank line between the header and
  -- the diff; preserve it. Patches ending in a lone `---` separator are
  -- left untouched (the separator itself already provides the spacing).
  local keep_blank_before_rest = sep_idx > 1
      and lines[sep_idx - 1] == ""
      and not lines[sep_idx]:match("^%-%-%-%s*$")

  local header, rest = {}, {}
  for i = 1, sep_idx - 1 do table.insert(header, lines[i]) end
  for i = sep_idx, #lines do table.insert(rest, lines[i]) end

  local parsed = parse_gitam_header(header) or parse_dep3_header(header, empty_line_char)
  if not parsed then
    vim.notify("dep3patch: unrecognized patch header format", vim.log.levels.ERROR)
    return
  end
  if not parsed.author then
    vim.notify("dep3patch: missing From/Author field", vim.log.levels.ERROR)
    return
  end

  local forwarded = parsed.forwarded or "not-needed"
  local last_update = last_update_date(cwd)

  local new_header = {}
  for i, line in ipairs(parsed.description) do
    if i == 1 then
      table.insert(new_header, "Description: " .. line)
    else
      table.insert(new_header, indent .. (line == "" and empty_line_char or line))
    end
  end
  table.insert(new_header, "Author: " .. parsed.author)
  table.insert(new_header, "Forwarded: " .. forwarded)
  table.insert(new_header, "Last-Update: " .. last_update)

  local new_lines = {}
  for _, line in ipairs(new_header) do table.insert(new_lines, line) end
  if keep_blank_before_rest then
    table.insert(new_lines, "")
  end
  for _, line in ipairs(rest) do table.insert(new_lines, line) end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
end

return M
