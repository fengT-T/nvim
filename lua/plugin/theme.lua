local themes = {
  onedark = {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    lazy = false,
  },
  github = {
    'projekt0n/github-nvim-theme',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  catppuccin = {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      flavour = 'latte',
      color_overrides = {
        transparent_background = false,
        latte = {
          base = '#ffffff',
        },
      },
      term_colors = true,
    },
  },
  bluloco = {
    'uloco/bluloco.nvim',
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    opts = {
      transparent = true,
    },
  },
}

return { themes.catppuccin }
