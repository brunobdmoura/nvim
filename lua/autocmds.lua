local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local user_group = augroup("user", {})

-- Remove empty spaces at the end of lines, except on
-- patch files, thanks Luppi.
autocmd("BufWritePre", {
  group = user_group,
  callback = function()
    if vim.fn.expand('%:e') ~= "patch" then
      vim.cmd([[%s/\s\+$//e]])
    end
  end
})

-- Avoid reaplying evals on statusline whenever opening quickfix list
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.statusline = ''
  end,
})

-- Set each terminal buffer as unlisted
autocmd("TermOpen", {
  group = user_group,
  callback = function()
    vim.api.nvim_set_option_value('bl', false, { buf = 0 })
  end,
})

local lang_meta_op = {
  c      = { format = "clang-format -i" },
  rust   = { format = "rustfmt", build = "cargo build" },
  ruby   = { small_indent = USER.indent_size / 2 },
  lua    = { small_indent = USER.indent_size / 2 },
}

for lang, data in pairs(lang_meta_op) do
  if data.format ~= nil then
    autocmd("FileType", {
      command = "nnoremap <leader><leader>f :!" .. data.format .. " % <CR>",
      pattern = lang
    })
  end
  if data.small_indent ~= nil then
    autocmd("FileType", {
      pattern = lang,
      callback = function()
        vim.opt_local.listchars:append({ leadmultispace = USER.indent_marker(data.small_indent) })
        vim.opt_local.shiftwidth = data.small_indent
        vim.opt_local.tabstop = data.small_indent
      end
    })
  end
end
