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
  -- 'tpope/vim-sleuth',

  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'j-hui/fidget.nvim',       opts = {} },
      { 'saghen/blink.cmp' },
    },
    config = require 'lsp-setup',
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = 'LazyVim',            words = { 'LazyVim' } },
        { path = 'lazy.nvim',          words = { 'LazyVim' } },
        { path = "snacks.nvim",        words = { "Snacks" } },
        { path = "flash.nvim",         words = { "Flash" } },
      },
    },
  },

  { 'b0o/schemastore.nvim' },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      preset = 'helix'
    }
  },
  { 'lewis6991/gitsigns.nvim', opts = require 'plugin.gitsigins' },
  {
    'nvim-lualine/lualine.nvim',
    opts = require 'plugin.lualine',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  -- { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = require 'plugin.indent-blankline' },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', lazy = false, },

  { 'RRethy/vim-illuminate' },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = "Trouble",
    opts = {
      signs = { error = '', warning = '', hint = '', information = '', other = '' },
      -- icons = true,
    },
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {}
  },

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
    opts = { enable_autocmd = false }
  },

  { 'windwp/nvim-ts-autotag',                 opts = {} },

  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- auto pairs
  {
    'echasnovski/mini.pairs',
    opts = {}
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {}
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
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    'timtro/glslView-nvim',
    opts = { viewer_path = 'glslviewer.exe' }
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = false,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  require 'plugin.ai',
  require 'plugin.theme',
  require 'plugin.conform',
  require 'plugin.flash',
  require 'plugin.cmp',
  require 'plugin.bufferline',
  require 'plugin.snacks',
  require 'plugin.dap',
  require 'plugin.clangd',
}, {})

-- vim: ts=2 sts=2 sw=2 et
