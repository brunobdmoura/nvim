local luna_status, luna = pcall(require, "luna")
if not luna_status then
  return {}
end

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
  normal            = { fg = colors.keyword, bg = colors.bg, bold = true },
  visual            = { fg = colors.cream,   bg = colors.bg, bold = true },
  insert            = { fg = colors.type,    bg = colors.bg, bold = true },
  select            = { fg = colors.silver,  bg = colors.bg, bold = true },
  replace           = { fg = colors.func,    bg = colors.bg, bold = true },
  quickfix          = { fg = colors.warning, bg = colors.bg, bold = true },
  shell             = { fg = colors.string,  bg = colors.bg, bold = true },
  terminal          = { fg = colors.info,    bg = colors.bg, bold = true },
  confirm           = { fg = colors.keyword, bg = colors.bg, bold = true },
  file_name         = { fg = colors.comment, bg = colors.bg, bold = true },
  line_filler       = { fg = colors.keyword, bg = colors.bg, bold = true },
  versioning_add    = { fg = colors.ok,      bg = colors.bg, bold = true },
  versioning_delete = { fg = colors.error,   bg = colors.bg, bold = true },
  versioning        = { fg = colors.ok,      bg = colors.bg, bold = true },
  file_type         = { fg = colors.comment, bg = colors.bg, bold = true },
  line_number       = { fg = colors.comment, bg = colors.bg, bold = true },
}

return {
  tabline_colors = tabline_colors,
  statusline_colors = statusline_colors
}
