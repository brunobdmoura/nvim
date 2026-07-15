local user_group = vim.api.nvim_create_augroup("user", {})

local autocmds = {
  -- Remove empty spaces at the end of lines, except on
  -- patch and changelog files, thanks Luppi.
  remove_white_spaces = {
    event = "BufWritePre",
    info = {
      group = user_group,
      callback = function()
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        if extension ~= "patch" and filename ~= "changelog" then
          vim.cmd([[%s/\s\+$//e]])
        end
      end
    }
  },
-- Set each terminal buffer as unlisted
  clean_quickfix_list = {
    event = "TermOpen",
    info = {
      group = user_group,
      callback = function()
        vim.api.nvim_set_option_value('bl', false, { buf = 0 })
      end,
    }
  },
  -- Avoid reaplying evals on statusline whenever opening quickfix list
  unlist_terminal_buffers = {
    event = "FileType",
    info = {
      group = user_group,
      callback = function()
        vim.opt_local.statusline = ''
      end,
    }
  }
}

for _, value in pairs(autocmds) do
  vim.api.nvim_create_autocmd(value.event, value.info)
end

local lang_meta_op = {
  c      = { format = "clang-format -i" },
  rust   = { format = "rustfmt", build = "cargo build" },
  ruby   = { small_indent = USER.indent_size / 2 },
  lua    = { small_indent = USER.indent_size / 2 },
  debchangelog = {
    format_changelog = {
      spacing = 2
    }
  }
}

for lang, data in pairs(lang_meta_op) do
  if data.format ~= nil then
    vim.api.nvim_create_autocmd("FileType", {
      command = "nnoremap <leader><leader>f :!" .. data.format .. " % <CR>",
      pattern = lang
    })
  end
  if data.small_indent ~= nil then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = lang,
      callback = function()
        vim.opt_local.listchars:append({ leadmultispace = USER.indent_marker(data.small_indent) })
        vim.opt_local.shiftwidth = data.small_indent
        vim.opt_local.tabstop = data.small_indent
      end
    })
  end
  if data.format_changelog then
    vim.api.nvim_create_autocmd("FileType", {
      group = user_group,
      pattern = lang,
      callback = function()
        vim.keymap.set("n", "<leader><leader>dc", function()
          require("debian.changelog").generate(data.format_changelog.spacing)
        end, { buffer = true, desc = "Generate debian/changelog entry from git history" })
      end
    })
  end
end
