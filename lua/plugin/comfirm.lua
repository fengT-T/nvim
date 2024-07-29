return {
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettier' },
    vue = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
  },
  -- just disable auto save
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
  formatters = {},
}
