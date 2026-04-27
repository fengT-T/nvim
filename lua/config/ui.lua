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

-- Show a little dot and the register char when recording a macro
local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return " REC " .. recording_register
  end
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
      lualine_c = { 'filename', 'codecompainon', { show_macro_recording, color = { fg = "#ff6666" } } },
      lualine_x = { 'searchcount', 'encoding', 'fileformat', 'filetype', 'lsp_status' },
      lualine_z = { { 'datetime', style = '%I:%M %p' } },
    },
  })
end

function M.ui2()
  -- Experimental UI2: floating cmdline and messages
  vim.o.cmdheight = 0
  require('vim._core.ui2').enable({
    enable = true,
    msg = {
      targets = {
        [''] = 'msg',
        empty = 'cmd',
        bufwrite = 'msg',
        confirm = 'cmd',
        emsg = 'pager',
        echo = 'msg',
        echomsg = 'msg',
        echoerr = 'pager',
        completion = 'cmd',
        list_cmd = 'pager',
        lua_error = 'pager',
        lua_print = 'msg',
        progress = 'pager',
        rpc_error = 'pager',
        quickfix = 'msg',
        search_cmd = 'cmd',
        search_count = 'cmd',
        shell_cmd = 'pager',
        shell_err = 'pager',
        shell_out = 'pager',
        shell_ret = 'msg',
        undo = 'msg',
        verbose = 'pager',
        wildlist = 'cmd',
        wmsg = 'msg',
        typed_cmd = 'cmd',
      },
      cmd = {
        height = 0.5,
      },
      dialog = {
        height = 0.5,
      },
      msg = {
        height = 0.3,
        timeout = 5000,
      },
      pager = {
        height = 0.5,
      },
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "msg",
    callback = function()
      local ui2 = require("vim._core.ui2")
      local win = ui2.wins and ui2.wins.msg
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_option_value(
          "winhighlight",
          "Normal:NormalFloat,FloatBorder:FloatBorder",
          { scope = "local", win = win }
        )
      end
    end,
  })

  local ui2 = require("vim._core.ui2")
  local msgs = require("vim._core.ui2.messages")
  local orig_set_pos = msgs.set_pos
  msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
      pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
        relative = "editor",
        anchor = "NE",
        row = 1,
        col = vim.o.columns - 1,
        border = "rounded",
        width = 50
      })
    end
  end

  vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(args)
      local client_id = args.data.client_id
      local client = vim.lsp.get_client_by_id(client_id)
      if not client then
        return
      end

      local value = args.data.params.value
      local msg_id = ("progress-lsp-%s"):format(client_id)
      local title = ("[%s] %s"):format(client.name or client_id, value.title)
      local msg = value.message or "finished"

      if value.kind == "end" then
        vim.api.nvim_echo({ { msg } }, false, {
          id = msg_id,
          kind = "progress",
          source = "vim.lsp",
          title = title,
          status = "success",
        })
      else -- "begin" or "report"
        vim.api.nvim_echo({ { msg } }, false, {
          id = msg_id,
          kind = "progress",
          source = "vim.lsp",
          title = title,
          status = "running",
          percent = value.percentage,
        })
      end
    end,
  })
end

return M
