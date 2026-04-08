return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    config = function()
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            'c',
            'cpp',
            'go',
            'lua',
            'python',
            'rust',
            'tsx',
            'javascript',
            'typescript',
            'vimdoc',
            'vim',
            'bash',
            'vue',
            'json',
            'scss',
            'css',
            'glsl',
            'wgsl',
            'yaml',
          },
          auto_install = true,
          sync_install = false,
          ignore_install = {},
          modules = {},
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<C-space>',
              node_incremental = '<C-space>',
              scope_incremental = false,
              node_decremental = '<bs>',
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              goto_next_start = {
                [']f'] = '@function.outer',
                [']c'] = '@class.outer',
                [']a'] = '@parameter.inner',
              },
              goto_next_end = {
                [']F'] = '@function.outer',
                [']C'] = '@class.outer',
                [']A'] = '@parameter.inner',
              },
              goto_previous_start = {
                ['[f'] = '@function.outer',
                ['[c'] = '@class.outer',
                ['[a'] = '@parameter.inner',
              },
              goto_previous_end = {
                ['[F'] = '@function.outer',
                ['[C'] = '@class.outer',
                ['[A'] = '@parameter.inner',
              },
            },
            swap = {
              enable = true,
              keymaps = {
                ['<leader>sa'] = '@parameter.inner',
                ['<leader>sf'] = '@function.outer',
              },
            },
          },
        }

        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end, 0)
    end,
  },

  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'windwp/nvim-ts-autotag', opts = {} },
}
