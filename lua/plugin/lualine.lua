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
          lualine_c = { 'filename' },
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
