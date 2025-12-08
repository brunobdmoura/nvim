function _G.fzf_lua_tag_word_under_cursor()
  -- Get the word under the cursor (equivalent to <cword> or <c-r><c-w>)
  local word = vim.fn.expand('<cword>')

  -- Check if the word is not empty
  if word ~= '' then
    -- Call fzf-lua tags command, pre-filling the query with the word
    require('fzf-lua').tags({
      query = word,
      -- Optional: You can set a specific winopts here if you want
      -- it to look different from your default fzf-lua configuration
    })
  else
    -- If there's no word, you might want to call the general tags picker
    -- or simply do nothing. This calls the general picker:
    require('fzf-lua').tags()
  end
end

-- Map the function to the desired key combination (e.g., <C-]> or g<C-]>).
-- We'll use <C-]> to match the built-in functionality.
vim.api.nvim_set_keymap(
  'n',
  '<leader><C-]>',
  '<cmd>lua fzf_lua_tag_word_under_cursor()<CR>',
  { noremap = true, silent = true, desc = 'FzfLua Tags for word under cursor' }
)
