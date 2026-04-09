local M = {}

function M.setup()
  local dap = require('dap')
  local dapui = require('dapui')

  if not dap.adapters['codelldb'] then
    dap.adapters['codelldb'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = { command = 'codelldb', args = { '--port', '${port}' } },
    }
  end

  for _, lang in ipairs({ 'c', 'cpp' }) do
    dap.configurations[lang] = {
      {
        type = 'codelldb',
        request = 'launch',
        name = 'Launch file',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
      },
      {
        type = 'codelldb',
        request = 'attach',
        name = 'Attach to process',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }
  end
  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  for name, sign in pairs({
    Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  }) do
    sign = type(sign) == 'table' and sign or { sign }
    vim.fn.sign_define('Dap' .. name, {
      text = sign[1],
      texthl = sign[2] or 'DiagnosticInfo',
      linehl = sign[3],
      numhl = sign[3]
    })
  end

  local vscode = require('dap.ext.vscode')
  local json = require('plenary.json')
  vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

  dapui.setup()
  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end

  require('mason-nvim-dap').setup({
    automatic_installation = true,
    handlers = {},
    ensure_installed = {},
  })

  require('nvim-dap-virtual-text').setup()
end

return M
