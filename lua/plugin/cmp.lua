return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets'
  },
  build = 'cargo build --release',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    signature = { enabled = true },
    keymap = {
      preset = 'default',
      -- ['<CR>'] = { 'accept', 'fallback' },
      -- cmdline = {
      --   preset = 'default'
      -- }
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        winblend = 30,
        draw = {
          treesitter = { 'lsp' }
        }
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
  },
  opts_extend = { "sources.default" }
}
