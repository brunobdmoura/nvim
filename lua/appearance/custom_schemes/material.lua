local material = require("material")

vim.g.material_style = "darker"

local colors = require("material.colors")

material.setup({
  styles = {
    comments = { italic = false },
    strings  = { bold = false },
    keywords = { bold = false },
  },
  custom_highlights = {
    ["@keyword"]               = { fg = colors.main.purple },
    ["@label"]                 = { fg = colors.main.paleblue },
    ["@punctuation"]           = { fg = colors.main.gray },
    ["@punctuation.delimiter"] = { fg = colors.main.gray },
    ["@type"]                  = { fg = colors.main.orange },
    NvimTreeIndentMarker       = { fg = colors.syntax.comments },
    MatchParen                 = { fg = colors.main.orange, bold = false },
    Macro                      = { fg = colors.main.cyan },
    String                     = { fg = colors.main.darkgreen },
    Operator                   = { fg = colors.main.darkred },
    -- Identifier                 = { fg = colors.main.purple},
  },
  custom_colors = function(colors)
    colors.main.orange = colors.main.darkorange
    colors.main.yellow = colors.main.darkyellow
    colors.main.green  = colors.main.darkgreen
    colors.main.blue   = colors.main.darkblue
    colors.main.cyan   = colors.main.darkcyan
    colors.main.purple = colors.main.darkpurple
    colors.main.orange = colors.main.darkorange
    colors.main.red    = colors.main.darkred
  end
})

local tabline_colors = {
  icon         = { fg = colors.main.orange,     bold = false },
  separator    = { fg = colors.main.yellow,     bold = true },
  active_tab   = { fg = colors.main.white,      bold = true },
  inactive_tab = { fg = colors.syntax.comments, bold = false }
}

local statusline_colors = {
  normal      = { fg = colors.main.orange,     bold = true },
  visual      = { fg = colors.main.red,        bold = true },
  insert      = { fg = colors.main.darkgreen,  bg = colors.syntax.comments,  bold = true },
  select      = { fg = colors.main.purple,     bold = true },
  replace     = { fg = colors.main.yellow,     bold = true },
  quickfix    = { fg = colors.main.orange,     bold = true },
  shell       = { fg = colors.main.green,      bold = true },
  terminal    = { fg = colors.main.blue,       bold = true },
  confirm     = { fg = colors.main.cyan,       bold = true },
  file_name   = { bg = colors.syntax.comments, bold = true },
  line_filler = { bg = colors.syntax.comments, fg = colors.syntax.comments, bold = false},
  versioning  = { bg = colors.main.green,      fg = colors.syntax.comments, bold = false},
  file_type   = { bg = colors.main.red,        fg = colors.syntax.comments, bold = false},
  line_number = { bg = colors.main.purple,     fg = colors.syntax.comments, bold = false}
}

vim.cmd("colorscheme material")

return {
  tabline_colors = tabline_colors,
  statusline_colors = statusline_colors
}
