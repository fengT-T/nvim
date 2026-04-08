return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require('util').diagnostics_icon
          local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
              .. (diag.warning and icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          { filetype = 'neo-tree', text = 'Neo-tree', highlight = 'Directory', text_align = 'left' },
        },
      },
    },
    config = function(_, opts)
      opts.highlights = require('catppuccin.special.bufferline').get_theme()
      require('bufferline').setup(opts)
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
        callback = function()
          vim.schedule(function()
            pcall(vim_bufferline)
          end)
        end,
      })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        },
        sections = {
          lualine_c = { 'filename', 'codecompainon' },
          lualine_x = { 'searchcount', 'encoding', 'fileformat', 'filetype' },
          lualine_z = { { 'datetime', style = '%I:%M %p' } },
        },
      })
    end,
  },
}
