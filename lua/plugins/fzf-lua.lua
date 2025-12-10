return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      fzf_colors = true,
      winopts = {
        backdrop = 100,
        preview = {
          scrollbar = false,
          hidden = "always"
        }
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      }
    })
  end,
  keys = function()
    local default_opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>sf", function()
      require("fzf-lua").files()
    end, default_opts)

    vim.keymap.set("n", "<leader>sb", function()
      require("fzf-lua").buffers()
    end, default_opts)

    vim.keymap.set("v", "<leader>/", function()
      require("fzf-lua").grep_visual()
    end, default_opts)

    vim.keymap.set("n", "<leader>/", function()
      require("fzf-lua").live_grep()
    end, default_opts)
  end
}
