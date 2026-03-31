function _G.fzf_lua_tag_word_under_cursor()
  -- Get the word under the cursor (equivalent to <cword> or <c-r><c-w>)
  local word = vim.fn.expand('<cword>')
  if word ~= '' then
    require('fzf-lua').tags({
      query = word,
    })
  else
    require('fzf-lua').tags()
  end
end

vim.api.nvim_set_keymap(
  'n',
  '<leader><C-]>',
  '<cmd>lua fzf_lua_tag_word_under_cursor()<CR>',
  { noremap = true, silent = true, desc = 'FzfLua Tags for word under cursor' }
)
