return {
  options = {
    theme = 'auto',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
  },
  sections = {
    lualine_c = { 'filename' },
    lualine_x = { 'searchcount', 'fileformat', 'filetype' },
    lualine_z = { 'tabs' },
  },
}
