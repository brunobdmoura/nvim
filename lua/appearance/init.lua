local tabline_colors = nil
local _statusline_colors = nil

local palettes = {
  kanagawa = "appearance.custom_schemes.kanagawa",
  material = "appearance.custom_schemes.material",
  catppuccin = "appearance.custom_schemes.catppuccin",
}

local colorscheme = require(palettes.kanagawa)
tabline_colors = colorscheme.tabline_colors
_statusline_colors = colorscheme.statusline_colors

require("appearance.tabline").setup({
  style  = "surrounded",
  tokens = {
    file_changed = '[+]',
    separators = { '|', '' },
    sub_separators = { '[', ']' }
  },
  colors = tabline_colors
})
