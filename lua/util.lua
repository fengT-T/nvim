local function get_fg(name)
  ---@type {foreground?:number}?
  ---@diagnostic disable-next-line: undefined-field
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  ---@diagnostic disable-next-line: undefined-field
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format('#%06x', fg) } or nil
end

--- copy form lazyvim
---@param buf number?
local function bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 then -- Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

local diagnostics_icon = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

return {
  get_fg = get_fg,
  bfm = bufremove,
  diagnostics_icon = diagnostics_icon,
  lualine_opts = {
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
  },
  gitsign_opt = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map({ 'n', 'v' }, ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'Jump to next hunk' })

      map({ 'n', 'v' }, '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'Jump to previous hunk' })

      -- Actions
      -- visual mode
      map('v', '<leader>hs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'stage git hunk' })
      map('v', '<leader>hr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'reset git hunk' })
      -- normal mode
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line { full = false }
      end, { desc = 'git blame line' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
      map('n', '<leader>hD', function()
        gs.diffthis '~'
      end, { desc = 'git diff against last commit' })

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
    end,
  },

  confirm_opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      vue = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
    },
    -- just disable auto save
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters = {},
  },
  flash_keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
  bufferline_options = {
    opts = {
      options = {
        close_command = function(n) bufremove(n) end,
        right_mouse_command = function(n) bufremove(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = diagnostics_icon
          local ret = (diag.error and icons.Error .. diag.error .. " " or "") -- just show error
          -- .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    },
  }
}
