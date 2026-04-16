local M = {}

local gh = function(repo)
  return 'https://github.com/' .. repo
end

function M.setup()
  vim.pack.add({
    { src = gh('folke/snacks.nvim'),           name = 'snacks.nvim' },
    { src = gh('catppuccin/nvim'),             name = 'catppuccin' },
    { src = gh('rktjmp/lush.nvim'),            name = 'lush.nvim' },
    { src = gh('nvim-tree/nvim-web-devicons'), name = 'nvim-web-devicons' },
    { src = gh('nvim-lua/plenary.nvim'),       name = 'plenary.nvim' },
  }, { load = true })

  require('config.tools').snacks()
  require('config.ui').theme()

  vim.pack.add({
    { src = gh('JoosepAlviste/nvim-ts-context-commentstring'), name = 'nvim-ts-context-commentstring' },
    { src = gh('folke/which-key.nvim'),                        name = 'which-key.nvim' },
    { src = gh('echasnovski/mini.pairs'),                      name = 'mini.pairs' },
    { src = gh('kylechui/nvim-surround'),                      name = 'nvim-surround' },
    { src = gh('folke/persistence.nvim'),                      name = 'persistence.nvim' },
    { src = gh('chentoast/marks.nvim'),                        name = 'marks.nvim' },
    { src = gh('folke/trouble.nvim'),                          name = 'trouble.nvim' },
    { src = gh('folke/todo-comments.nvim'),                    name = 'todo-comments.nvim' },
    { src = gh('MeanderingProgrammer/render-markdown.nvim'),   name = 'render-markdown.nvim' },
    { src = gh('timtro/glslView-nvim'),                        name = 'glslView-nvim' },
  }, { load = true })
  require('config.editor').setup()

  vim.pack.add({
    { src = gh('akinsho/bufferline.nvim'),   name = 'bufferline.nvim' },
    { src = gh('nvim-lualine/lualine.nvim'), name = 'lualine.nvim' },
  }, { load = true })
  require('config.ui').ui()
  require('config.ui').ui2()

  vim.pack.add({
    { src = gh('lewis6991/gitsigns.nvim'), name = 'gitsigns.nvim' },
  }, { load = true })
  require('config.git').setup()

  -- vim.pack.add({
    -- { src = gh('saghen/blink.cmp'),             name = 'blink.cmp',        version = vim.version.range('*') },
   -- { src = gh('rafamadriz/friendly-snippets'), name = 'friendly-snippets' },
  -- }, { load = true })
--  require('config.lsp').cmp()


  vim.pack.add({
    { src = gh('neovim/nvim-lspconfig'),             name = 'nvim-lspconfig' },
    { src = gh('williamboman/mason.nvim'),           name = 'mason.nvim' },
    { src = gh('williamboman/mason-lspconfig.nvim'), name = 'mason-lspconfig.nvim' },
    -- { src = gh('j-hui/fidget.nvim'),                 name = 'fidget.nvim' },
    { src = gh('b0o/schemastore.nvim'),              name = 'schemastore.nvim' },
    { src = gh('p00f/clangd_extensions.nvim'),       name = 'clangd_extensions.nvim' },
  }, { load = true })

  vim.pack.add({
    { src = gh('Civitasv/cmake-tools.nvim'),                   name = 'cmake-tools.nvim' },
    { src = gh('stevearc/conform.nvim'),                       name = 'conform.nvim' },
    { src = gh('nvim-treesitter/nvim-treesitter'),             name = "nvim-treesitter",   branch = "main" },
    { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), branch = "main",            name = "nvim-treesitter-textobjects" },
    { src = gh('windwp/nvim-ts-autotag'),                      name = "nvim-ts-autotag" },
    { src = gh('ibhagwan/fzf-lua'),                            name = 'fzf-lua' },
    { src = gh('folke/flash.nvim'),                            name = 'flash.nvim' },
    { src = gh('olimorris/codecompanion.nvim'),                name = 'codecompanion.nvim' },
  }, { load = true })

  require('config.treesitter').setup()
  require('config.lsp').setup()
  require('config.tools').formatting()
  require('config.tools').fzf()
  require('config.tools').flash()
  require('config.tools').ai()

  vim.pack.add({
    { src = gh('mfussenegger/nvim-dap'),           name = 'nvim-dap' },
    { src = gh('rcarriga/nvim-dap-ui'),            name = 'nvim-dap-ui' },
    { src = gh('theHamsta/nvim-dap-virtual-text'), name = 'nvim-dap-virtual-text' },
    { src = gh('nvim-neotest/nvim-nio'),           name = 'nvim-nio' },
    { src = gh('jay-babu/mason-nvim-dap.nvim'),    name = 'mason-nvim-dap.nvim' },
    { src = gh('folke/lazydev.nvim'),              name = 'lazydev.nvim' },
  }, { load = true })
  require('config.dap').setup()

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    once = true,
    callback = function()
      require('lazydev').setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "LazyVim",            words = { "LazyVim" } },
          { path = "snacks.nvim",        words = { "Snacks" } },
          { path = "lazy.nvim",          words = { "LazyVim" } },
          { path = "nvim-lspconfig",     words = { "lspconfig.settings" } },
        },
      })
    end,
  })
end

return M
