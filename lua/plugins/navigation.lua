return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    vscode = true,
    opts = {},
    keys = {
      { 's',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash' },
      { 'S',     mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Toggle Flash Search' },
    },
  },

  -- {
  --   'mikavilpas/yazi.nvim',
  --   event = 'VeryLazy',
  --   dependencies = { 'folke/snacks.nvim' },
  --   keys = {
  --     { '<leader>-',  mode = { 'n', 'v' },    '<cmd>Yazi<cr>',                                           desc = 'Open yazi at the current file' },
  --     { '<leader>cw', '<cmd>Yazi cwd<cr>',    desc = "Open the file manager in nvim's working directory" },
  --     { '<c-up>',     '<cmd>Yazi toggle<cr>', desc = 'Resume the last yazi session' },
  --   },
  --   opts = {
  --     open_for_directories = false,
  --     integrations = { grep_in_directory = 'fzf-lua', grep_in_selected_files = 'fzf-lua' },
  --     keymaps = { show_help = '<f1>' },
  --   },
  --   init = function()
  --     vim.g.loaded_netrw = 1
  --     vim.g.loaded_netrwPlugin = 1
  --   end,
  -- },
}
