return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      -- Default behavioural usage and bindings whenever selecting cmp options.
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert}),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert}),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" }
      },
      -- Window configuration, purely display related.
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:Normal,CursorLine:PmenuSel,Search:None,CmpItemKind:Type,CmpItemAbbrMatch:Identifier",
          minwidth = 60,
        }),
      },
      experimental = {
        ghost_text = false
      }
    })
  end
}
