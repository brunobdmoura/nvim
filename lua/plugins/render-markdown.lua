return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      local default_opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>mt", function()
        require('render-markdown').toggle()
      end, default_opts)
    end
}
