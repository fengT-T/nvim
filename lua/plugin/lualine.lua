local function codeiumStatus()
  local suffix = '󱙺 '
  local codeium = require('codeium.virtual_text').status_string()
  if codeium == nil or codeium == '' then
    return suffix
  else
    return suffix .. codeium
  end
end

local function copilotStatus()
  local suffix = ' '
  local status = require("copilot.api").status.data.status
  return suffix .. ((status == "InProgress" and "...") or (status == "Warning" and "err") or "ok")
end

return {
  options = {
    theme = 'auto',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
  },
  sections = {
    lualine_c = { 'filename' },
    lualine_x = { 'searchcount', 'encoding', 'fileformat', 'filetype', codeiumStatus, copilotStatus },
    lualine_z = { { 'datetime', style = '%I:%M %p' } },
  },
}
