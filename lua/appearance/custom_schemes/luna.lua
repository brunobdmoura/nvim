local luna_status, luna = pcall(require, "luna")
if not luna_status then
  return {}
end

-- local tb = {
--   bg = "#060606",
--   bg_alt = "#1c1c1c",
--   bg_delete = "#40000a",
--   bg_plum = "#302028",
--   bg_soft = "#1f1f1f",
--   black = "#000000",
--   border = "#404040",
--   comment = "#7c7c7c",
--   cream = "#f0e0d6",
--   cursor_line = {
--     bg = "#212121"
--   },
--   cursor_line_nr = {
--     fg = "#c7c7c7"
--   },
--   diag = {
--     error = "#e08585",
--     hint = "#b09080",
--     info = "#8c9cb8",
--     ok = "#6fbe80",
--     warning = "#d9a35a"
--   },
--   error = "#e08585",
--   fg = "#e4e4e8",
--   fg_bright = "#f0f0f0",
--   float_bg = "#403c41",
--   float_border = "#404040",
--   func = "#75a1c7",
--   git = {
--     add = {
--       bg = "#152017",
--       fg = "#6fbe80"
--     },
--     change = {
--       bg = "#191410",
--       fg = "#c2916a"
--     },
--     delete = {
--       bg = "#40000a",
--       fg = "#e08585"
--     },
--     text = {
--       bg = "#3e3024",
--       fg = "#f0f0f0"
--     }
--   },
--   grey = "#888888",
--   grey_light = "#a8a8a8",
--   grey_mid = "#989898",
--   grey_pale = "#b8b8b8",
--   grey_warm = "#605958",
--   hint = "#b09080",
--   info = "#8c9cb8",
--   keyword = "#e19067",
--   line_nr = "#2f2b2b",
--   none = "NONE",
--   number = "#e19067",
--   ok = "#6fbe80",
--   selection = "#384048",
--   signal = "#c2916a",
--   silver = "#c7c7c7",
--   string = "#9eb38e",
--   surface = "#333333",
--   type = "#c4a8d6",
--   visual = "#404040",
--   warning = "#d9a35a",
--   white = "#ffffff"
-- }

-- colors = require("luna.palette")

-- vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FzfLuaPreviewBorder" })
-- vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.keyword })
-- vim.api.nvim_set_hl(0, "@property.lua", { fg = colors.cream })


require("luna").setup({
  transparent = false,
  accent = 0.7, -- 0-1, blends syntax accents toward grey_light; 1 = full color
  plugins = {
    all = false, -- enable every plugin integration unconditionally
    -- auto = true, -- when plugins.all is false, autodetect via lazy.nvim
  },
  on_highlights = function(hl, colors)
    hl["FzfLuaBorder"] =  { fg = colors.border }
    hl["MatchParen"]  =  { fg = colors.keyword, bold = true }
    hl["Property"] = { fg = colors.cream }
  end
})

vim.cmd.colorscheme("luna")

local colors = require("luna.palette")

local tabline_colors = {
  separator    = { fg = colors.keyword, bold = true },
  active_tab   = { fg = colors.fg,      bold = true },
  inactive_tab = { fg = colors.comment, bold = false }
}

local statusline_colors = {
  normal      = { fg = colors.keyword, bg = colors.bg, bold = true },
  visual      = { fg = colors.cream,   bg = colors.bg, bold = true },
  insert      = { fg = colors.type,    bg = colors.bg, bold = true },
  select      = { fg = colors.silver,  bg = colors.bg, bold = true },
  replace     = { fg = colors.func,    bg = colors.bg, bold = true },
  quickfix    = { fg = colors.warning, bg = colors.bg, bold = true },
  shell       = { fg = colors.string,  bg = colors.bg, bold = true },
  terminal    = { fg = colors.info,    bg = colors.bg, bold = true },
  confirm     = { fg = colors.keyword, bg = colors.bg, bold = true },
  file_name   = { fg = colors.comment, bg = colors.bg, bold = true },
  line_filler = { fg = colors.keyword, bg = colors.bg, bold = true },
  versioning  = { fg = colors.ok,      bg = colors.bg, bold = true },
  file_type   = { fg = colors.comment, bg = colors.bg, bold = true },
  line_number = { fg = colors.comment, bg = colors.bg, bold = true },
}

return {
  tabline_colors = tabline_colors,
  statusline_colors = statusline_colors
}
