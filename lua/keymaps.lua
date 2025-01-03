-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- file tree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'nvim three toggle' })
vim.keymap.set('n', '<leader>E', '<cmd>NvimTreeFindFile<cr>', { desc = 'nvim tree find File' })

-- save
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- remove buffer copy from lazyvim
vim.keymap.set('n', '<leader>d', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })

-- restore the session for the current directory
vim.keymap.set('n', '<leader>qs', require('persistence').load, { desc = 'restore current session' })
-- restore the last session
vim.keymap.set('n', '<leader>ql', require('persistence').load, { desc = 'restore last session' })
-- stop Persistence => session won't be saved on exit
vim.keymap.set('n', '<leader>qd', require('persistence').load, { desc = 'stop persistence' })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- format
vim.keymap.set('n', '<leader>cf', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Format buffer' })

vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set('n', '<leader>cQ', '<cmd>Trouble qflist toggle<cr>', { desc = "Quickfix list (Trouble)" })
vim.keymap.set('n', '<leader>cL', '<cmd>Trouble loclist toggle<cr>', { desc = "Location list (Trouble)" })
vim.keymap.set('n', '<leader>cX', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Diagnostics (Trouble)" })
vim.keymap.set('n', '<leader>cx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = "Buffer Diagnostics (Trouble)" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
  vim.keymap.set("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
  vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
end

-- toggle options
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", {
  off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level"
}):map("<leader>uc")
Snacks.toggle.option("showtabline", {
  off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline"
}):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", {
  off = "light", on = "dark", name = "Dark Background",
}):map("<leader>ub")
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- fzf-lua
local function searhBuf()
  require('fzf-lua').buffers { sort_mru = true, sort_lastused = true }
end
vim.keymap.set('n', '<leader>so', require('fzf-lua').builtin, { desc = '[S]earch [O]pen' })
-- lsp
vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gI', require('fzf-lua').lsp_implementations, { desc = '[G]oto [I]mplementation' })
vim.keymap.set('n', 'gy', require('fzf-lua').lsp_typedefs, { desc = '[G]oto [Y]pe Definition' })
vim.keymap.set('n', '<leader>cs', require('fzf-lua').lsp_document_symbols, { desc = '[C]ode [S]ymbols' })
vim.keymap.set('n', '<leader>cD', require('fzf-lua').lsp_document_diagnostics, { desc = '[C]ode [D]iagnostics' })
vim.keymap.set('n', '<leader>ca', require('fzf-lua').lsp_code_actions, { desc = '[C]ode [A]ctions' })
-- workspace lsp
vim.keymap.set('n', '<leader>ss', require('fzf-lua').lsp_workspace_symbols, { desc = '[S]earch [S]ymbols' })
vim.keymap.set('n', '<leader>sd', require('fzf-lua').lsp_workspace_diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sS', require('fzf-lua').lsp_live_workspace_symbols,
  { desc = '[S]earch [W]orkspace Symbols' })
-- grep workspace word
vim.keymap.set('n', '<leader>s/', require('fzf-lua').live_grep, { desc = '[S]earch [G]rep' })
vim.keymap.set('n', '<leader>sw', require('fzf-lua').grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>s"', require('fzf-lua').registers, { desc = '[S]earch [R]egisters' })
vim.keymap.set('n', '<leader>sr', require('fzf-lua').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sj', require('fzf-lua').jumps, { desc = '[S]earch [J]umplist' })
vim.keymap.set('n', '<leader>sk', require('fzf-lua').keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sl', require('fzf-lua').loclist, { desc = '[S]earch [L]ocation list' })
vim.keymap.set('n', '<leader>sm', require('fzf-lua').marks, { desc = '[S]earch [M]arks' })
vim.keymap.set('n', '<leader>sh', require('fzf-lua').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sc', require('fzf-lua').commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader>sC', require('fzf-lua').command_history, { desc = '[S]earch [C]ommand [H]istory' })
vim.keymap.set('n', '<leader>sg', require('fzf-lua').git_status, { desc = '[S]earch [G]it [S]tatus' })
vim.keymap.set('n', '<leader>sgc', require('fzf-lua').git_commits, { desc = '[S]earch [G]it [C]ommits' })
vim.keymap.set('n', '<leader>sgb', require('fzf-lua').git_branches, { desc = '[S]earch [G]it [B]ranches' })
-- search workspace file
vim.keymap.set('n', '<leader>sb', searhBuf, { desc = 'Search [B]uffers' })
vim.keymap.set('n', '<leader>sO', require('fzf-lua').oldfiles, { desc = 'Search [O]ldfiles' })
vim.keymap.set('n', '<leader>f', require('fzf-lua').files, { desc = 'Search Files' })
vim.keymap.set('n', '<leader><space>', searhBuf, { desc = 'Search Buffers' })
-- grep current buff
vim.keymap.set('n', '<leader>/', require('fzf-lua').lgrep_curbuf, { desc = 'Search current Buffer' })

require('which-key').add {
  { '<leader>c', group = 'Code' },
  { '<leader>g', group = 'Git' },
  { '<leader>s', group = 'Search' },
  { '<leader>b', group = 'Buffer' },
  { '<leader>u', group = 'UI Toggle' },
  { '<leader>w', group = 'Workspace' },
  { '<leader>q', group = 'Project' },
}

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- vim: ts=2 sts=2 sw=2 et
