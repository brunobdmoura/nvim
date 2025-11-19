-- Shamelessly based on luatab https://github.com/alvarosevilla95/luatab.nvim
local helpers = {}

--- Concatenates all of the elements in the @tbl table into a single string.
---@param tbl table: a table of strings
---@return string
function helpers.format_table(tbl)
  return table.concat(tbl)
end

--- Applies the contour to a given text.
---@param text string: the text to be contoured
---@param separators table: a table with two elements, the left and right separators
---@return string
function helpers.contour(text, separators)
  return separators[1] .. text .. separators[#separators]
end

--- Transforms a highlight name into a useful highlight string.
---@param str string: the name of the highlight group
---@return string
function helpers.highlightfy(str)
  return helpers.format_table({ '%', '#', str, '#' })
end

-- Defines all of the highlight groups to their configuration values.

--- Sets the highlights according to the user's configuration.
---@param highlights table: a table with the highlight group names
---@param colors table: a table with the highlight group definitions
---@return nil
function helpers.set_config_highlights(highlights, colors)
  for name, hl_string in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl_string, colors[name])
  end
end

--- Defines all of the highlight groups to link the @default group when
--- there is no configuration.
---@param highlights table: a table with the highlight group names
---@param default_group string: the name of the highlight group to link to
---@return nil
function helpers.set_non_config_highlights(highlights, default_group)
  for _, hl_string in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl_string, { link = default_group })
  end
end

--- Gets the default tokens when there is no user configuration.
---@return table
function helpers.get_non_config_tokens()
  return {
    file_changed = '+',
    separators = {'', ''},
    sub_separators = {'(', ')'}
  }
end

local M = {}

M._data = {}

M._data.tokens = {}

M._data.highlights = {
  separator    = "TabLineSeparator",
  active_tab   = "TabLineActiveTab",
  inactive_tab = "TabLineInactiveTab"
}

M._data.colors = {
  separator    = helpers.highlightfy(M._data.highlights.separator),
  active_tab   = helpers.highlightfy(M._data.highlights.active_tab),
  inactive_tab = helpers.highlightfy(M._data.highlights.inactive_tab)
}

--- Generates the title of a given buffer.
---@param bufnr number: the buffer number
---@param is_selected boolean: whether the buffer is in the selected tab
---@return string
function M.title(bufnr, is_selected)
  -- Access current buffer information.
  local file = vim.fn.bufname(bufnr)
  local buftype = vim.fn.getbufvar(bufnr, "&buftype")
  local filetype = vim.fn.getbufvar(bufnr, "&filetype")

  -- Set both tables with possible buffer and file types for its
  -- respective return strings.
  local buftypes = {
    ['help']     = "Help:" .. vim.fn.fnamemodify(file, ":t:r"),
    ['quickfix'] = "Quickfix",
    ['terminal'] = vim.fn.fnamemodify(vim.env.SHELL, ":t"),
  }

  local filetypes = {
    ["git"]                 = "Git",
    ["fugitive"]            = "Fugitive",
    ["NvimTree"]            = "NvimTree",
    ["DiffviewFileHistory"] = "Diffview",
  }

  -- Then, lazyly check those tables if buffer variables are empty.
  local title = ""
  if file == "" and buftype == "" and filetype == "" then
    title = "No_file"
  elseif buftypes[buftype] then
    title = buftypes[buftype]
  elseif filetypes[filetype] then
    title = filetypes[filetype]
  else
    title = vim.fn.pathshorten(vim.fn.fnamemodify(file, ":p:~:t"))
  end

  -- Add the file icon.
  --[[ if M._required.devicons then
    title = string.format("%s %s", title, M._required.devicons.get_icon(file, filetype, { default = true }))
  end ]]

  -- And finally, ensure a proper highlighting if the current cell is selected.
  local cell_title = is_selected
    and { M._data.colors.active_tab, title, " " }
    or { M._data.colors.inactive_tab, title, M._data.colors.inactive_tab, " " }

  return helpers.format_table(cell_title)
end

--- Checks if a given buffer is modified and returns the corresponding token.
---@param bufnr number: the buffer number
---@return string
function M.modified(bufnr)
  local modified = vim.fn.getbufvar(bufnr, "&modified") == 1 and true or false
  return modified and M._data.tokens.file_changed .. " " or ""
end

--- Counts the number of windows in a given tabpage.
---@param index number: the tabpage index
---@return string
function M.window_count(index)
  local nwins = 0
  local ok, wins = pcall(vim.api.nvim_tabpage_list_wins, index)
  if ok then
    for _ in pairs(wins) do
      nwins = nwins + 1
    end
  end

  if nwins == 1 then
    return ""
  else
    return helpers.format_table({
      helpers.contour(nwins, M._data.tokens.sub_separators), " "
    })
  end
end

--- Generates a cell for a given tabpage index.
---@param index number: the tabpage index
---@param is_selected boolean: whether the tabpage is selected
---@return string
function M.cell(index, is_selected)
  local buflist = vim.fn.tabpagebuflist(index)
  local winnr = vim.fn.tabpagewinnr(index)
  local bufnr = buflist[winnr]

  return helpers.format_table({
    "%", index, "T", " ",
    M.window_count(index),
    M.title(bufnr, is_selected), "%T",
    M.modified(bufnr),
  })
end

--- Evaluates the style for a given cell.
---@param index number: the tabpage index
---@param cell string: the content of the cell
---@param is_selected boolean: whether the cell is selected
---@return string
function M.eval_style(index, cell, is_selected)
  local styles = {
    ["surrounded"] = function(index, cell, is_selected)
      if is_selected then
        local text = helpers.format_table({
          M._data.colors.active_tab, cell, M._data.colors.separator
        })
        return helpers.format_table({
          M._data.colors.separator,
          helpers.contour(text, M._data.tokens.separators)
        })
      else
        return helpers.format_table({
          M._data.colors.inactive_tab,
          helpers.contour(cell, M._data.tokens.separators)
        })
      end
    end
  }
  return styles[M._data.style](index, cell, is_selected)
end

--- Generates the tabline string.
---@return string
function M.tabline()
  -- Start building the tabline.
  local line = ""
  for index = 1, vim.fn.tabpagenr("$"), 1 do
    -- Check if the current cell is selected.
    local is_selected = vim.fn.tabpagenr() == index
    -- Then, access its content.
    local cell = M.cell(index , is_selected)
    -- Eval the current @style and add the cell to the tabline.
    cell = M.eval_style(index , cell, is_selected)
    line = line .. cell
  end
  -- Finally, return the built line plus the @inactive_tab color for the rest
  -- of the window.
  return line .. M._data.colors.inactive_tab
end

--- Evaluates the configuration provided by the user.
---@param config table: a table with the configuration parameters
function M.eval_config(config)
  if config.tokens then
    M._data.tokens = config.tokens
  else
    M._data.tokens = helpers.get_non_config_tokens()
  end

  if config.style then
    M._data.style = config.style
  else
    M._data.style = "surrounded"
  end

  M._required = {}

  if config.colors then
    helpers.set_config_highlights(M._data.highlights, config.colors)
  else
    helpers.set_non_config_highlights(M._data.highlights, "String")
  end

  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    M._required.devicons = devicons
  end
end

--- Sets up the tabline with the given configuration.
---@param config table: a table with the configuration parameters
function M.setup(config)
  M.eval_config(config)
  vim.opt.tabline = "%!v:lua.require(\"appearance.tabline\").tabline()"
end

return M
