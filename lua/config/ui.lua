local M = {}

local diagnostics_icon = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

function M.theme()
  require('catppuccin').setup({
    flavour = 'latte',
    color_overrides = {
      transparent_background = true,
      latte = { base = '#ffffff' },
    },
    term_colors = true,
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      indent_blankline = { enabled = true },
      lsp_trouble = true,
      mason = true,
      markdown = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
      neotest = true,
      snacks = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  })
  vim.cmd.colorscheme('catppuccin')
end

function M.ui()
  require('bufferline').setup({
    options = {
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and diagnostics_icon.Error .. diag.error .. ' ' or '')
            .. (diag.warning and diagnostics_icon.Warn .. diag.warning or '')
        return vim.trim(ret)
      end,
    },
  })

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
end

return M
