return {
  options = {
    theme = 'auto',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
  },
  sections = {
    lualine_c = { 'filename' },
    lualine_x = { 'searchcount', 'encoding', 'fileformat', 'filetype' },
    lualine_z = { { 'datetime', style = '%I:%M %p' } },
  },
}
