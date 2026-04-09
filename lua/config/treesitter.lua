local M = {}

function M.setup()
  require("nvim-treesitter").setup({})
  require("nvim-treesitter").install({
    "bash",
    "c",
    "cpp",
    "diff",
    "go",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "query",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  })

  require("nvim-treesitter-textobjects").setup {}
  require('nvim-ts-autotag').setup {}


  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
      pcall(vim.treesitter.start, ev.buf)
    end
  })


  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name == 'nvim-treesitter' and kind == 'update' then
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        vim.cmd('TSUpdate')
      end
    end
  })
end

return M
