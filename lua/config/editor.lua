local M = {}

function M.setup()
  require('ts_context_commentstring').setup {
    enable_autocmd = false
  }

  local get_option = vim.filetype.get_option
  vim.filetype.get_option = function(filetype, option)
    return option == "commentstring"
        and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
  end

  require('which-key').setup({ preset = 'helix' })

  require('mini.pairs').setup()
  require('nvim-surround').setup()

  require('persistence').setup({
    dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
  })

  require('marks').setup()

  require('trouble').setup({
    signs = {
      error = '',
      warning = '',
      hint = '',
      information = '',
      other = '',
    },
  })

  require('todo-comments').setup()

  require('render-markdown').setup({
    file_types = { 'markdown', 'codecompanion' },
  })

  require('glslView').setup({ viewer_path = 'glslviewer.exe' })
end

return M
