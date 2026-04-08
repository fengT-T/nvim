return {
  'stevearc/conform.nvim',
  dependencies = { 'mason.nvim' },
  lazy = true,
  cmd = 'ConformInfo',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      vue = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
    },
    format_on_save = false,
    formatters = {},
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
