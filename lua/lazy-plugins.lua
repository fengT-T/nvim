-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  -- 'tpope/vim-fugitive',
  -- 'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'j-hui/fidget.nvim',       opts = {} },
      { 'folke/neodev.nvim',       opts = {} },
    },
  },
  { "b0o/schemastore.nvim" },
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    lazy = true,
    cmd = 'ConformInfo',
    opts = require('util').confirm_opts,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      -- 'L3MON4D3/LuaSnip',
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
          global_snippets = { "all", "global" },
          create_cmp_source = true
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },

      -- 'saadparwaiz1/cmp_luasnip',
      -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = require('util').gitsign_opt,
  },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   lazy = false,
  -- },
  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  -- },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      flavour         = 'latte',
      color_overrides = {
        transparent_background = false,
        latte = {
          base = "#ffffff",
        },
      },
    },
  },
  {
    'uloco/bluloco.nvim',
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    opts = {
      transparent = false,
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = require('util').lualine_opts,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  -- {
  --   'echasnovski/mini.bufremove',
  -- },
  {
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    opts = {
      -- symbol = "▏",
      symbol = '│',
      options = { try_as_border = true },
    },
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    lazy = false,
    -- init in treesitter
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
  },

  {
    'RRethy/vim-illuminate',
  },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      signs = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '',
      },
      icons = true,
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    'windwp/nvim-ts-autotag',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {}
  },

  -- auto pairs
  {
    'echasnovski/mini.pairs',
    config = function()
      require('mini.pairs').setup()
    end,
  },
  {
    'folke/persistence.nvim',
    -- this will only start session saving when an actual file was opened
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'), -- directory where session files are saved
    },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = {
      config = {
        header = require 'logo',
      },
    },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = require 'util'.bufferline_options.opts,
    keys = require 'util'.bufferline_options.keys,
    config = require 'util'.bufferline_options.config,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = require 'util'.flash_keys,
  }
}, {})

-- vim: ts=2 sts=2 sw=2 et
