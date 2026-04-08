return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      fuzzy = { sorts = { 'score', 'sort_text', 'label' } },
      signature = { enabled = true },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { winblend = 10, draw = { treesitter = { 'lsp' } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
      },
      cmdline = { enabled = false },
    },
    opts_extend = { 'sources.default' },
  },
  { 'saghen/blink.compat', optional = true, opts = {}, version = not vim.g.lazyvim_blink_main and '*' },
}
