local catpuccin_status, catpuccin = pcall(require, "catppuccin")
if not catpuccin_status then
  return {}
end

local scheme = require("catppuccin.palettes").get_palette("macchiato")

local plastlin = {
  rosewater = "#eb7a73",
  flamingo  = "#eb7a73",
  red       = "#eb7a73",
  maroon    = "#eb7a73",
  pink      = "#e396a4",
  mauve     = "#e396a4",
  peach     = "#e89a5e",
  yellow    = "#e8b267",
  green     = "#b9c675",
  teal      = "#99c792",
  sky       = "#99c792",
  sapphire  = "#99c792",
  blue      = "#8dbba3",
  lavender  = "#8dbba3",
  text      = "#f1e4c2",
  subtext1  = "#e5d5b1",
  subtext0  = "#c5bda3",
  overlay2  = "#b8a994",
  overlay1  = "#a39284",
  overlay0  = "#656565",
  surface2  = "#5d5d5d",
  surface1  = "#505050",
  surface0  = "#393939",
  base      = "#2e3233",
  mantle    = "#242727",
  crust     = "#1f2223",
}

-- scheme = plastlin

catpuccin.setup({
  flavour = "mocha",
  no_italic = true,
  no_bold = true,
  no_underline = true,
  custom_highlights = {
    ["@variable.member"]   = { fg = plastlin.subtext0  },
    ["@property"]          = { fg = plastlin.subtext0  },
      CursorLineNr         = { fg = plastlin.peach },
      WinSeparator         = { fg = scheme.surface2 },
      FloatBorder          = { fg = scheme.surface2, bg = scheme.base },
      NvimTreeNormal       = { fg = scheme.text,     bg = scheme.base },
      NvimTreeIndentMarker = { fg = scheme.surface2, bg = scheme.base },
      NvimTreeNormalFloat  = { fg = scheme.text,     bg = scheme.base },
      NvimTreeEndOfBuffer  = { fg = scheme.base },
      NvimTreeStatusLine   = { fg = scheme.text,     bg = scheme.base },
  },
  background = {
    dark = "mocha",
  },
  color_overrides = {
      mocha = scheme,
  },
})

vim.cmd("colorscheme catppuccin")

local tabline_colors = {
  icon         = { fg = scheme.crust,    bold = false },
  separator    = { fg = scheme.peach,    bold = true },
  active_tab   = { fg = scheme.text,     bold = true },
  inactive_tab = { fg = scheme.surface2, bold = false }
}

local statusline_colors = {
  normal      = { fg = scheme.peach,     bold = true },
  visual      = { fg = scheme.maroon,    bold = true },
  insert      = { fg = scheme.pink,    bg = scheme.surface2, bold = true },
  select      = { fg = scheme.maroon,    bold = true },
  replace     = { fg = scheme.lavender,  bold = true },
  quickfix    = { fg = scheme.pink,      bold = true },
  shell       = { fg = scheme.green,     bold = true },
  terminal    = { fg = scheme.overlay1,  bold = true },
  confirm     = { fg = scheme.overlayy1, bold = true },
  file_name   = { fg = scheme.text,      bg = scheme.surface2 },
  line_filler = { fg = scheme.surface2,  bg = scheme.surface2 },
  versioning  = { bg = scheme.teal, fg = scheme.base },
  file_type   = { bg = scheme.red,  fg = scheme.base },
  line_number = { bg = scheme.blue, fg = scheme.base }
}

return {
  tabline_colors = tabline_colors,
  statusline_colors = statusline_colors
}
