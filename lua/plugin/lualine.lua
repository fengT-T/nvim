return {
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        },
        sections = {
          lualine_c = { 'filename', 'codecompainon' },
          lualine_x = {
            { require("minuet.lualine"), display_name = "provider", display_on_idle = true },
            'searchcount', 'encoding', 'fileformat', 'filetype',
          },
          lualine_z = { { 'datetime', style = '%I:%M %p' } },
        },
      })
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
}
