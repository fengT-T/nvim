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
    },
    config = require 'lsp-setup',
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'LazyVim',            words = { 'LazyVim' } },
        { path = 'lazy.nvim',          words = { 'LazyVim' } },
      },
    },
  },

  { 'b0o/schemastore.nvim' },
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    lazy = true,
    cmd = 'ConformInfo',
    opts = require 'plugin.comfirm',
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'garymjr/nvim-snippets',
        opts = {
          friendly_snippets = true,
          global_snippets = { 'all', 'global' },
          create_cmp_source = true,
        },
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',     opts = {} },
  { 'lewis6991/gitsigns.nvim',  opts = require 'plugin.gitsigins' },
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-lualine/lualine.nvim',
    opts = require 'plugin.lualine',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = require 'plugin.indent-blankline' },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',               lazy = false },

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
    config = require 'telescope-setup',
  },

  { 'RRethy/vim-illuminate' },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = "Trouble",
    opts = {
      signs = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '',
      },
      -- icons = true,
    },
  },

  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    }
  },

  { 'windwp/nvim-ts-autotag',                 opts = {} },

  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
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
    opts = require 'plugin.dashboard',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
  },

  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = require('plugin.bufferline').opts,
    keys = require('plugin.bufferline').keys,
    config = require('plugin.bufferline').config,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    vscode = true,
    ---@type Flash.Config
    opts = {},
    keys = require 'plugin.flash',
  },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      direction = 'float'
    }
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    'Exafunction/codeium.vim',
    event = 'BufEnter'
  },
  require('plugin.theme').bluloco,
  require('plugin.theme').github,
  require('plugin.theme').catppuccin,
}, {})

-- vim: ts=2 sts=2 sw=2 et
