return {
  'folke/lazydev.nvim',
  ft = 'lua',
  cmd = 'LazyDev',
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'LazyVim', words = { 'LazyVim' } },
      { path = 'lazy.nvim', words = { 'LazyVim' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'flash.nvim', words = { 'Flash' } },
    },
  },
}
