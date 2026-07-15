local tabline_colors = nil
local statusline_colors = nil

local palettes = {
  kanagawa = "appearance.custom_schemes.kanagawa",
  material = "appearance.custom_schemes.material",
  catppuccin = "appearance.custom_schemes.catppuccin",
  kanso = "appearance.custom_schemes.kanso",
}

local colorscheme = require(palettes.kanagawa)
tabline_colors = colorscheme.tabline_colors
statusline_colors = colorscheme.statusline_colors

require("appearance.tabline").setup({
  style  = "surrounded",
  tokens = {
    file_changed = '[+]',
    separators = { '|', '' },
    sub_separators = { '[', ']' }
  },
  colors = tabline_colors
})

require("appearance.statusline").setup({
  tokens = {
    separators = { ' ', ' ' }
  },
  colors = statusline_colors,
  use_cached_for = { "NvimTree", "fzf" }
})

