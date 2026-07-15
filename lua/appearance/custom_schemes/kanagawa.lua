local kanagawa_status, kanagawa = pcall(require, "kanagawa")
if not kanagawa_status then
  return {}
end

kanagawa.setup({
  -- Remove bold and/or italic tokens and remove background from
  -- from ui edges.
  keywordStyle   = { italic = false, bold = false },
  statementStyle = { italic = false, bold = false },
  commentStyle   = { italic = false, bold = false },
  constantStyle  = { italic = false, bold = false },
  colors = {
    theme = {
      dragon = {
        ui = {
          bg_gutter = "none",
        }
      }
    }
  },
  overrides = function(colors)
    -- Basically turn the background darker, correct border colors, remove unused italics
    -- and add some custom configurations
    return {
      CursorLineNr               = { bold = false },
      MatchParen                 = { bold = false },
      NormalFloat                = { bg = "none" },
      FloatTitle                 = { bg = "none" },
      Keyword                    = { fg = colors.palette.dragonRed },
      Boolean                    = { bold = false },
      CursorLine                 = { bg = colors.palette.dragonBlack4 },
      FloatBorder                = { bg = "none", fg = colors.palette.dragonBlack4 },
      WinSeparator               = { fg = colors.palette.dragonBlack4 },
      FzfLuaBorder               = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonBlack3 },
      IblIndent                  = { fg = colors.palette.dragonBlack4 },
      NvimTreeIndentMarker       = { fg = colors.palette.dragonBlack6 },
      ["@variable.builtin"]      = { italic = false },
      ["@keyword.operator"]      = { bold = false },
      ["@keyword.return"]        = { bold = false },
      ["@string.documentation.python"] = {link = "Comment"},
      StatusLineNC =  { fg = "none", bg = "none" },
      StatusLine   =  { fg = "none", bg = "none" },
    }
  end
})

require("kanagawa").load("dragon")
local kolors = require("kanagawa.colors").setup()

-- Both tabline and statusline colors are only defined if a colorscheme is loaded,
-- in this case, kanagawa.
local tabline_colors = {
  separator    = { fg = kolors.palette.roninYellow, bold = true },
  active_tab   = { fg = kolors.palette.dragonWhite, bold = true },
  inactive_tab = { fg = kolors.palette.fujiGray,    bold = false }
}

local statusline_colors = {
  normal      = { fg = kolors.palette.dragonOrange, bold = true },
  visual      = { fg = kolors.palette.dragonRed,    bold = true },
  insert      = { fg = kolors.palette.dragonGreen,  bold = true },
  select      = { fg = kolors.palette.dragonViolet, bold = true },
  replace     = { fg = kolors.palette.dragonYellow, bold = true },
  quickfix    = { fg = kolors.palette.dragonOrange, bold = true },
  shell       = { fg = kolors.palette.dragonGray,   bold = true },
  terminal    = { fg = kolors.palette.dragonBlue,   bold = true },
  confirm     = { fg = kolors.palette.dragonPink,   bold = true },
  file_name   = { fg = kolors.palette.dragonBlack6, bold = true },
  line_filler = { fg = kolors.palette.dragonBlack6, bold = true },
  versioning  = { fg = kolors.palette.dragonGreen,  bold = true },
  file_type   = { fg = kolors.palette.dragonBlack6, bold = true },
  line_number = { fg = kolors.palette.dragonBlack6, bold = true },
}

return {
  tabline_colors = tabline_colors,
  statusline_colors = statusline_colors,
}
