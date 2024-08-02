-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'snippets' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' },
--   },
-- })
-- vim: ts=2 sts=2 sw=2 et
