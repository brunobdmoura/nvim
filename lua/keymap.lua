local function map(mode, key, command, opts)
  opts = opts or { noremap = false, silent = true }
  vim.keymap.set(mode, key, command, opts)
end

-- General utils
map("n", "<leader>i", "i<CR><Esc><S-o>")

-- Split movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-q>", "<C-w>q")

-- Tab movement
map("n", "<", ":tabp<CR>")
map("n", ">", ":tabn<CR>")
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Lazy movement
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Quickfix movement
map("n", "J", ":cnext<CR>")
map("n", "K", ":cprev<CR>")

-- Lazy saving/quitting
map("n", "<leader>w", ":w<CR>")

-- Overide shenanigans
map("n", "<leader>rw", "cw<C-r>0<C-c>")
map("v", "p", '"_dP')

-- Terminal shenanigans
map("t", "<C-c>", "<C-\\><C-n>")
map({ "n", "t" }, "<leader>t", ":FloatingTerminal <CR>")

-- Copy paste from outside/within vim; requires xclip
map("v", "<Enter>", [["+y]]) -- To be used with the same behavior as tmux
map("n", "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- Visual mode identation
map("v", "<Tab>",   ">gv")
map("v", "<S-Tab>", "<gv")

-- Visual mode line movement
map("v", "J", ":m '>+1'<CR>gv=gv")
map("v", "K", ":m '<-2'<CR>gv=gv")

-- Split/window resizing
map("n", "<C-Down>",  ":resize -2 <CR>")
map("n", "<C-Up>",    ":resize +2 <CR>")
map("n", "<C-Left>",  ":vertical resize -2 <CR>")
map("n", "<C-Right>", ":vertical resize +2 <CR>")

-- Show LSP diagnostics
map("n", "<leader>ds", function()
  vim.diagnostic.open_float(nil, {
    focusable = false, border = "rounded"
  })
end)
