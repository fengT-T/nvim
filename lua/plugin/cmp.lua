return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets'
    },
    version = '*',
    -- build = 'cargo build --release',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },
      fuzzy = {
        sorts = {
          "score", "exact", "sort_text"
        }
      },
      signature = {enabled = true},
      sources = {
        -- with blink.compat
        -- compat = {},
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          winblend = 10,
          draw = {
            treesitter = { 'lsp' }
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true
        },
      },
      cmdline = {
        enabled = false,
      }
    },
    opts_extend = { "sources.default" }
  },
  {
    "saghen/blink.compat",
    optional = true, -- make optional so it's only enabled if any extras need it
    opts = {},
    version = not vim.g.lazyvim_blink_main and "*",
  }
}
