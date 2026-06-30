vim.g.mapleader = USER.leader_key
-- Vim stuff when handling latex related files; simply easier to just set it
-- to always be latex
vim.g.tex_flavor = "latex"

local configs = {
  tabstop        = USER.indent_size,
  softtabstop    = USER.indent_size,
  shiftwidth     = USER.indent_size,
  expandtab      = true,
  smartindent    = true,
  autoindent     = true,
  number         = true,
  numberwidth    = 4,
  relativenumber = true,
  hlsearch       = false,
  hidden         = true,
  errorbells     = false,
  wrap           = false,
  backup         = false,
  writebackup    = false,
  swapfile       = false,
  undodir        = os.getenv("HOME") .. "/.config/nvim/undodir",
  undofile       = true,
  ignorecase     = true,
  smartcase      = true,
  incsearch      = true,
  scrolloff      = 12,
  foldlevel      = 99,
  foldlevelstart = 99,
  foldenable     = true,
  encoding       = "utf-8",
  autoread       = true,
  cmdheight      = 1,
  termguicolors  = true,
  cursorline     = true,
  laststatus     = 3,
  showtabline    = 3,
  list           = true,
  fillchars      = {
    fold = "۰",
    diff = "·"
  },
  listchars      = {
    tab = "»·", trail = "·", eol = "¬",
    leadmultispace = USER.indent_marker(USER.indent_size),
  },
}

for key, val in pairs(configs) do
  vim.opt[key] = val
end
