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
  -- { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = require 'plugin.indent-blankline' },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',   lazy = false, },

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
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      "folke/snacks.nvim"
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  require 'plugin.fzf-lua',
  require 'plugin.ai',
  require 'plugin.theme',
  require 'plugin.conform',
  require 'plugin.flash',
  require 'plugin.cmp',
  require 'plugin.bufferline',
  require 'plugin.snacks',
  require 'plugin.dap',
  require 'plugin.clangd',
  require 'plugin.lualine'
}, {})

-- vim: ts=2 sts=2 sw=2 et
