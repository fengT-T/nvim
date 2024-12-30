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
    opts = require 'plugin.conform',
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
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
        ['<CR>'] = { 'accept', 'fallback' },
        cmdline = {
          preset = 'default'
        }
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'normal'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { "sources.default" }
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',    opts = {} },
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
  { 'numToStr/Comment.nvim', lazy = false },

  -- {
  --   'nvim-telescope/telescope.nvim',
  --   branch = '0.1.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  --     -- Only load if `make` is available. Make sure you have the system
  --     -- requirements installed.
  --     {
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --       build = 'make',
  --       cond = function()
  --         return vim.fn.executable 'make' == 1
  --       end,
  --     },
  --     { 'nvim-telescope/telescope-ui-select.nvim' },
  --   },
  --   config = require 'telescope-setup',
  -- },

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
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bufdelete    = { enabled = true },
      input        = { enabled = true },
      bigfile      = { enabled = true },
      dashboard    = require "plugin.dashboard",
      lazygit      = { enabled = true },
      indent       = { enabled = true },
      quickfile    = { enabled = true },
      scope        = { enabled = true },
      statuscolumn = { enabled = true },
      toggle       = { enabled = true },
      notifier     = { enabled = true },
      notify       = { enabled = true }
    }
  },
  {
    'timtro/glslView-nvim',
    opts = { viewer_path = 'glslviewer.exe' }
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      'default-title',
      fzf_colors = true,
    }
  },
  require('plugin.ai').copilot,
  require('plugin.ai').codeium,
  require('plugin.theme').bluloco,
  require('plugin.theme').github,
  require('plugin.theme').catppuccin,
}, {})

-- vim: ts=2 sts=2 sw=2 et
