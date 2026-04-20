return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local i = ls.insert_node
    local t = ls.text_node
    local extras = require("luasnip.extras")
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = extras.rep

    local tex = {
      -- begin/end block
      s("beg", fmt(
        [[
        \begin{{{}}}
            {}
        \end{{{}}}
        ]], {
          i(1), i(0), rep(1)
        })
      ),
      -- items
      s("item", fmt([[\item {} ]], {i(1)})),
      s("item", fmt([[\item \textbf{{{}}} ]], {i(1)})),
      s("item", fmt([[\item \emph{{{}}} ]], {i(1)})),
      s("item", fmt([[\item \textbf{{\emph{{{}}}}} ]], {i(1)})),
    }

    local c = {
      s("struct", fmt(
        [[
        /* {} definition. */
        typedef struct {{
          {}
        }} {};
        ]], {
          rep(1), i(0), i(1)
        })
      ),
      s("for", fmt(
        [[
        for ({}; {}; {}) {{
            {}
        }}
        ]], {
          i(1), i(2), i(3), i(0)
        })
      ),
      s("while", fmt(
        [[
        while ({}) {{
            {}
        }}
        ]], {
          i(1), i(0)
        })
      ),
    }

    local ruby = {
      s("module", fmt(
        [[
        # {} module.
        module {}
          {}
        end
        ]], {
          rep(1), i(1, "ModuleName"), i(0)
        })
      ),
      s("class", fmt(
        [[
        # {} class definition.
        class {}
          def initialize({})
            {}
          end
        end
        ]], {
          rep(1), i(1, "ClassName"), i(2, "args"), i(0)
        })
      ),
      s("each", fmt(
        [[
        each do |{}|
          {}
        end
        ]], {
          i(1, "item"), i(0)
        })
      ),
    }

    local all = {
      s("gbp", {
        t("LP: #"),
        i(1, "0123456"),
        t({ "", "Gbp-Dch: full" })
      })
    }

    local custom_snips = {
      tex = tex, c = c, lua = {}, ruby = ruby, cpp = c, all = all
    }

    for filetype, snips in pairs(custom_snips) do
      ls.add_snippets(filetype, snips)
    end
  end,
  keys = function()
    local default_opts = { noremap = true, silent = true }
    local ls = require("luasnip")
    -- Jump to the next snippet.
    vim.keymap.set("i", "<C-j>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, default_opts)
    -- Jump to the previous snippet.
    vim.keymap.set("i", "<C-k>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, default_opts)
  end
}
