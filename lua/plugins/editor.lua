return {
  { 'numToStr/Comment.nvim', lazy = false },
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true, opts = { enable_autocmd = false } },

  {
    'folke/which-key.nvim',
    opts = { preset = 'helix' }
  },

  { 'echasnovski/mini.pairs', opts = {} },
  { 'kylechui/nvim-surround', event = 'VeryLazy', opts = {} },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/') },
  },

  { 'chentoast/marks.nvim', event = 'VeryLazy', opts = {} },
  { 'RRethy/vim-illuminate' },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    opts = { signs = { error = '', warning = '', hint = '', information = '', other = '' } },
  },

  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },

  { 'MeanderingProgrammer/render-markdown.nvim', lazy = false, ft = { 'markdown', 'codecompanion' }, opts = {} },
  { 'timtro/glslView-nvim', opts = { viewer_path = 'glslviewer.exe' } },
}
