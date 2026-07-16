-- Generates the body of a debian/changelog entry from the last N git commits
-- (N prompted from the user), grouped by author, formatted per Debian
-- conventions (e.g. "  * d/foo: did something").
local M = {}

local WIDTH = 70

--- Runs `cmd` in `cwd` via the shell and returns its stdout split into lines.
---@param cwd string: directory to run the command in
---@param cmd string: shell command to execute
---@return table: list of output lines
local function run(cwd, cmd)
  return vim.fn.systemlist(string.format("cd %s && %s", vim.fn.shellescape(cwd), cmd))
end

--- Wraps `text` into a list of lines no wider than WIDTH columns, without
--- splitting words. The first line is prefixed with `prefix`; subsequent
--- wrapped lines are prefixed with `cont_indent`.
---@param text string: the text to wrap
---@param prefix string: prefix prepended to the first line
---@param cont_indent string: prefix prepended to wrapped continuation lines
---@return table: list of wrapped lines
local function wrap(text, prefix, cont_indent)
  local lines = {}
  local current = prefix

  for word in text:gmatch("%S+") do
    local candidate = (current == prefix or current == cont_indent)
        and (current .. word)
        or (current .. " " .. word)

    if #candidate > WIDTH and current ~= prefix and current ~= cont_indent then
      table.insert(lines, current)
      current = cont_indent .. word
    else
      current = candidate
    end
  end
  table.insert(lines, current)
  return lines
end

--- Runs `git log` for the last `count` commits in `cwd` and splits them into
--- blocks by consecutive author runs, preserving git history order (e.g.
--- authors A,A,B,A produce three blocks: A, B, A).
---@param cwd string: git repository (or subdirectory) to run `git log` in
---@param count number: number of most recent commits to include
---@return table: list of blocks, each `{ author = string, commits = table }`
local function group_commits_into_blocks(cwd, count)
  local cmd = string.format('git log -n %d --pretty=format:"%%an|%%s" --reverse', count)
  local raw = run(cwd, cmd)
  local blocks = {}

  for _, line in ipairs(raw) do
    local author, subject = line:match("^(.-)|(.*)$")
    if author and subject and subject ~= "" then
      local last = blocks[#blocks]
      if not last or last.author ~= author then
        last = { author = author, commits = {} }
        table.insert(blocks, last)
      end
      table.insert(last.commits, subject)
    end
  end
  return blocks
end

--- Renders `blocks` into a list of changelog body lines, indented by
--- `spacing` (`spacing + 2` for wrapped continuation lines). Author headers
--- (`[ Name ]`) are only emitted when there is more than one block.
---@param blocks table: list of blocks as returned by group_commits_into_blocks
---@param spacing number: number of leading spaces before each line
---@return table: list of formatted changelog body lines
local function compose_body(blocks, spacing)
  local indent = string.rep(" ", spacing)
  local cont_indent = string.rep(" ", spacing + 2)
  local body = {}
  local show_headers = #blocks > 1

  for _, block in ipairs(blocks) do
    if show_headers then
      table.insert(body, indent .. "[ " .. block.author .. " ]")
    end
    for _, subject in ipairs(block.commits) do
      for _, l in ipairs(wrap(subject, indent .. "* ", cont_indent)) do
        table.insert(body, l)
      end
    end
    if show_headers then
      table.insert(body, "")
    end
  end
  if show_headers and body[#body] == "" then
    table.remove(body)
  end
  return body
end

--- Opens a small floating prompt window asking the user for a single line
--- of input. Calls `on_confirm(text)` once the user presses <CR>; does not
--- call it if they cancel with <Esc> or <C-c>.
---@param title string: title shown on the floating window's border
---@param on_confirm function: called with the entered text on confirmation
---@return nil
local function float_input(title, on_confirm)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = 40
  local height = 1

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })

  vim.bo[buf].buftype = "prompt"
  vim.fn.prompt_setprompt(buf, "> ")

  local function close()
    -- prompt buffers stay in Insert mode after <CR>; leave it explicitly so
    -- focus doesn't return to the target buffer still in Insert mode (which
    -- would make keys like `u` type text instead of undoing).
    vim.cmd("stopinsert")
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.fn.prompt_setcallback(buf, function(text)
    close()
    -- Defer the confirm callback to the next event-loop tick. Running it
    -- synchronously here (still inside the prompt buffer's <CR>/close
    -- handling) makes Neovim record buffer edits without a proper undo-tree
    -- entry: the undo sequence counter advances but no undoable state is
    -- saved, so `u` reports "Already at oldest change" and can't revert it.
    vim.schedule(function()
      on_confirm(text)
    end)
  end)

  for _, mode in ipairs({ "i", "n" }) do
    vim.keymap.set(mode, "<Esc>", close, { buffer = buf })
  end
  vim.keymap.set("i", "<C-c>", close, { buffer = buf })

  vim.cmd("startinsert!")
end

--- Prompts for a number of commits via a floating input, then generates a
--- debian/changelog entry body from that many recent commits (grouped by
--- consecutive author) and inserts it into the current buffer beneath the
--- cursor line that was active when this was invoked.
---@param spacing number|nil: leading spaces per line; defaults to 2
---@return nil
function M.generate(spacing)
  spacing = spacing or 2

  local target_buf = vim.api.nvim_get_current_buf()
  local target_win = vim.api.nvim_get_current_win()
  local pkg_root = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(target_buf), ":h:h")
  local row = vim.api.nvim_win_get_cursor(target_win)[1]

  float_input("Number of (last) commits to include", function(input)
    local count = tonumber(input)
    if not count or count <= 0 then
      vim.notify("Invalid number of commits", vim.log.levels.ERROR)
      return
    end

    local blocks = group_commits_into_blocks(pkg_root, count)
    if #blocks == 0 then
      vim.notify("No new commits since last changelog entry", vim.log.levels.WARN)
      return
    end

    local body = compose_body(blocks, spacing)
    vim.api.nvim_buf_set_lines(target_buf, row, row, false, body)
  end)
end

--- Runs `dch -i` against the package containing the current buffer's
--- debian/changelog, adding a new entry stanza (or reopening the last one if
--- still unreleased) without spawning an external editor, then reloads the
--- buffer so the new entry shows up in the current window.
---@return nil
function M.exec_dch()
  local target_buf = vim.api.nvim_get_current_buf()
  local pkg_root = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(target_buf), ":h:h")

  -- Passing a null string as the changelog text puts dch in batch mode
  -- without adding any text, so it never spawns an editor to confirm the
  -- new stanza (which would otherwise abort with "changelog unmodified"
  -- since nothing actually edits the temp file).
  local cmd = string.format("cd %s && dch -i ''", vim.fn.shellescape(pkg_root))
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("dch failed: " .. output, vim.log.levels.ERROR)
    return
  end

  vim.cmd("edit!")
end

return M
