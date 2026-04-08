local M = {}

local gh = function(repo)
  return 'https://github.com/' .. repo
end

function M.setup()
  vim.pack.add({
    { src = gh('folke/snacks.nvim'), name = 'snacks.nvim' },
    { src = gh('catppuccin/nvim'), name = 'catppuccin' },
    { src = gh('rktjmp/lush.nvim'), name = 'lush.nvim' },
    { src = gh('nvim-tree/nvim-web-devicons'), name = 'nvim-web-devicons' },
    { src = gh('nvim-lua/plenary.nvim'), name = 'plenary.nvim' },
  }, { load = true })

  local plugins = require('config.plugins')
  plugins.snacks()
  plugins.theme()

  vim.pack.add({
    { src = gh('numToStr/Comment.nvim'), name = 'Comment.nvim' },
    { src = gh('JoosepAlviste/nvim-ts-context-commentstring'), name = 'nvim-ts-context-commentstring' },
    { src = gh('folke/which-key.nvim'), name = 'which-key.nvim' },
    { src = gh('echasnovski/mini.pairs'), name = 'mini.pairs' },
    { src = gh('kylechui/nvim-surround'), name = 'nvim-surround' },
    { src = gh('folke/persistence.nvim'), name = 'persistence.nvim' },
    { src = gh('chentoast/marks.nvim'), name = 'marks.nvim' },
    { src = gh('folke/trouble.nvim'), name = 'trouble.nvim' },
    { src = gh('folke/todo-comments.nvim'), name = 'todo-comments.nvim' },
    { src = gh('MeanderingProgrammer/render-markdown.nvim'), name = 'render-markdown.nvim' },
    { src = gh('timtro/glslView-nvim'), name = 'glslView-nvim' },
  }, { load = true })
  plugins.editor()

  vim.pack.add({
    { src = gh('akinsho/bufferline.nvim'), name = 'bufferline.nvim' },
    { src = gh('nvim-lualine/lualine.nvim'), name = 'lualine.nvim' },
  }, { load = true })
  plugins.ui()

  vim.pack.add({
    { src = gh('lewis6991/gitsigns.nvim'), name = 'gitsigns.nvim' },
  }, { load = true })
  plugins.git()

  vim.pack.add({
    { src = gh('saghen/blink.cmp'), name = 'blink.cmp', version = vim.version.range('*') },
    { src = gh('rafamadriz/friendly-snippets'), name = 'friendly-snippets' },
  }, { load = true })
  plugins.cmp()

  vim.pack.add({
    { src = gh('neovim/nvim-lspconfig'), name = 'nvim-lspconfig' },
    { src = gh('williamboman/mason.nvim'), name = 'mason.nvim' },
    { src = gh('williamboman/mason-lspconfig.nvim'), name = 'mason-lspconfig.nvim' },
    { src = gh('j-hui/fidget.nvim'), name = 'fidget.nvim' },
    { src = gh('b0o/schemastore.nvim'), name = 'schemastore.nvim' },
    { src = gh('p00f/clangd_extensions.nvim'), name = 'clangd_extensions.nvim' },
  }, { load = true })

  vim.pack.add({
    { src = gh('Civitasv/cmake-tools.nvim'), name = 'cmake-tools.nvim' },
    { src = gh('stevearc/conform.nvim'), name = 'conform.nvim' },
    { src = gh('romus204/tree-sitter-manager.nvim'), name = 'tree-sitter-manager.nvim' },
    { src = gh('ibhagwan/fzf-lua'), name = 'fzf-lua' },
    { src = gh('folke/flash.nvim'), name = 'flash.nvim' },
    { src = gh('olimorris/codecompanion.nvim'), name = 'codecompanion.nvim' },
  }, { load = true })

  plugins.lsp()
  plugins.formatting()
  plugins.treesitter()
  plugins.fzf()
  plugins.flash()
  plugins.ai()

  vim.pack.add({
    { src = gh('mfussenegger/nvim-dap'), name = 'nvim-dap' },
    { src = gh('rcarriga/nvim-dap-ui'), name = 'nvim-dap-ui' },
    { src = gh('theHamsta/nvim-dap-virtual-text'), name = 'nvim-dap-virtual-text' },
    { src = gh('nvim-neotest/nvim-nio'), name = 'nvim-nio' },
    { src = gh('jay-babu/mason-nvim-dap.nvim'), name = 'mason-nvim-dap.nvim' },
    { src = gh('folke/lazydev.nvim'), name = 'lazydev.nvim' },
  }, { load = true })
  plugins.dap()

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    once = true,
    callback = function()
      require('lazydev').setup({
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          { path = 'snacks.nvim', words = { 'Snacks' } },
          { path = 'flash.nvim', words = { 'Flash' } },
        },
      })
    end,
  })
end

return M
