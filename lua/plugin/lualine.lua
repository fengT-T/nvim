local function codeiumStatus()
  local suffix = '󱙺'
  local codeium = vim.api.nvim_call_function("codeium#GetStatusString", {})
  if codeium == nil or codeium == '' then
    return suffix
  else
    return suffix .. codeium
  end
end

return {
  options = {
    theme = 'auto',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
  },
  sections = {
    lualine_c = { 'filename' },
    lualine_x = { 'searchcount', 'encoding', 'fileformat', 'filetype', codeiumStatus },
    lualine_z = { { 'datetime', style = '%I:%M %p' } },
  },
}
