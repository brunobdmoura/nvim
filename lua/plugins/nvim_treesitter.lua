return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = USER.treesitter.parsers,
      highlight = { enable = true, },
      indent = { enable = false, },
    })
  end
}
