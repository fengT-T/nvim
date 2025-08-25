package.path = package.path .. ';../util.lua' -- 添加父目录的 lib 路径到搜索路径

local util = require 'util'

return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      close_command = function(n)
        util.bufremove(n)
      end,
      right_mouse_command = function(n)
        util.bufremove(n)
      end,
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = util.diagnostics_icon
        local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') -- just show error
            .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  },
  config = function(_, opts)
    opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
    require('bufferline').setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
