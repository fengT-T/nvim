local themes = {
  catppuccin = {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'latte',
      color_overrides = {
        transparent_background = true,
        latte = { base = '#ffffff' },
      },
      term_colors = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        neotest = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  bluloco = {
    'uloco/bluloco.nvim',
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    opts = { guicursor = true, transparent = true },
  },
}

return { themes.catppuccin, themes.bluloco, themes.catppuccin }
