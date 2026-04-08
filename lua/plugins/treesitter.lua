return {
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  --   build = ':TSUpdate',
  --   branch = "main",
  --   init = function()
  --     require('nvim-treesitter').install { 'c',
  --       'cpp',
  --       'go',
  --       'lua',
  --       'python',
  --       'rust',
  --       'tsx',
  --       'javascript',
  --       'typescript',
  --       'vimdoc',
  --       'vim',
  --       'bash',
  --       'vue',
  --       'json',
  --       'scss',
  --       'css',
  --       'glsl',
  --       'wgsl',
  --       'yaml',
  --     }
  --   end,
  -- },
  --
  -- { 'nvim-treesitter/nvim-treesitter-context' },
  -- { 'windwp/nvim-ts-autotag',                 opts = {} },
  --
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require("tree-sitter-manager").setup({
        -- Optional: custom paths
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      })
    end
  }
}
