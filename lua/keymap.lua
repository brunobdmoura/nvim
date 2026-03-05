--- Custom default options function
local function copts(opts)
  if opts.noremap == nil then
    opts.noremap = false
  end

  if opts.silent == nil then
    opts.silent = true
  end

  return opts
end

vim.keymap.set("n", "<leader>nt", ":tabnew<CR>", copts({ desc = "Creates a new tab" }))
vim.keymap.set("n", "<leader>ca", ":tabo<CR>", copts({ desc = "Closes all tabs except the current one" }))

vim.keymap.set("n", "<C-h>", "<C-w>h", copts({ desc = "Moves to right window" }))
vim.keymap.set("n", "<C-j>", "<C-w>j", copts({ desc = "Moves to bottom window" }))
vim.keymap.set("n", "<C-k>", "<C-w>k", copts({ desc = "Moves to upper window" }))
vim.keymap.set("n", "<C-l>", "<C-w>l", copts({ desc = "Moves to left window" }))
vim.keymap.set("n", "<C-q>", "<C-w>q", copts({ desc = "Closes window" }))

vim.keymap.set("n", "<", ":tabp<CR>", copts({ desc = "Next tab" }))
vim.keymap.set("n", ">", ":tabn<CR>", copts({ desc = "Previous tab" }))
vim.keymap.set("n", "<S-l>", ":bnext<CR>", copts({ desc = "Next buffer" }))
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", copts({ desc = "Previous buffer" }))

vim.keymap.set("n", "<C-d>", "<C-d>zz", copts({ desc = "Half page down centered" }))
vim.keymap.set("n", "<C-u>", "<C-u>zz", copts({ desc = "Half page up centered" }))

vim.keymap.set("n", "J", ":cnext<CR>", copts({ desc = "Next quickfix entry" }))
vim.keymap.set("n", "K", ":cprev<CR>", copts({ desc = "Previous quickfix entry" }))

vim.keymap.set("n", "<leader>w", ":w<CR>", copts({ desc = "Save buffer" }))

vim.keymap.set("n", "<leader>rw", "cw<C-r>0<C-c>", copts({ desc = "Override the current word with yanked text" }))
vim.keymap.set("v", "p", '"_dP', copts({ desc = "Paste without yanking" }))

vim.keymap.set("t", "<leader><C-c>", "<C-\\><C-n>", copts({ desc = "'Escapes' the open floating terminal" }))
vim.keymap.set({ "n", "t" }, "<leader>t", ":FloatingTerminal <CR>", copts({ desc = "Opens the floating terminal" }))

vim.keymap.set("v", "<Enter>", [["+y]], copts({ desc = "Copies selected text to clipboard (same behavior as tmux)" }))
vim.keymap.set("n", "<leader>y", [["+y]], copts({ desc = "Copies select text to clipboard" }))
vim.keymap.set("n", "<leader>Y", [["+Y]], copts({ desc = "Copies select text to clipboard" }))

vim.keymap.set("v", "<Tab>",   ">gv", copts({ desc = "Indent right and reselect" }))
vim.keymap.set("v", "<S-Tab>", "<gv", copts({ desc = "Indent left and reselect" }))

vim.keymap.set("v", "J", ":m '>+1'<CR>gv=gv", copts({ desc = "Move selected whole selected line down" }))
vim.keymap.set("v", "K", ":m '<-2'<CR>gv=gv", copts({ desc = "Move selected whole selected line up" }))

vim.keymap.set("n", "<C-Down>",  ":resize -2 <CR>", copts({ desc = "Resize split down" }))
vim.keymap.set("n", "<C-Up>",    ":resize +2 <CR>", copts({ desc = "Resice split up" }))
vim.keymap.set("n", "<C-Left>",  ":vertical resize -2 <CR>", copts({ desc = "Resize split left" }))
vim.keymap.set("n", "<C-Right>", ":vertical resize +2 <CR>", copts({ desc = "Resize split right" }))

vim.keymap.set("n", "<leader>ds", function()
  vim.diagnostic.open_float(nil, {
    focusable = false, border = "rounded"
  }, copts({ desc = "Opens diagnostic window" }))
end)
