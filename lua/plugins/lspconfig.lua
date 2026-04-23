return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    -- Default capabilities for all servers
    vim.lsp.config('*', {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      on_attach = function(_, bufnr)
        local map_opts = { buffer = bufnr }
        vim.keymap.set("n", ";", vim.lsp.buf.hover, map_opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
        vim.keymap.set("n", "rn", vim.lsp.buf.rename, map_opts)
      end,
    })

    for _, server in pairs(USER.lsp.servers) do
      if USER.lsp.settings[server] then
        vim.lsp.config(server, USER.lsp.settings[server])
      end
      vim.lsp.enable(server)
    end
  end
}
