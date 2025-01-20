-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- File tree
map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'nvim tree toggle' })
map('n', '<leader>E', '<cmd>NvimTreeFindFile<cr>', { desc = 'nvim tree find File' })

-- Save
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Remove buffer copy from lazyvim
map('n', '<leader>d', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })

-- Persistence
local persistence = require('persistence')
map('n', '<leader>qs', persistence.load, { desc = 'restore current session' })
map('n', '<leader>ql', persistence.load, { desc = 'restore last session' })
map('n', '<leader>qd', persistence.load, { desc = 'stop persistence' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Format
map('n', '<leader>cf', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Format buffer' })

-- Trouble
local trouble = require('trouble')
map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = "LSP Definitions / references / ... (Trouble)" })
map('n', '<leader>cQ', '<cmd>Trouble qflist toggle<cr>', { desc = "Quickfix list (Trouble)" })
map('n', '<leader>cL', '<cmd>Trouble loclist toggle<cr>', { desc = "Location list (Trouble)" })
map('n', '<leader>cX', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Diagnostics (Trouble)" })
map('n', '<leader>cx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = "Buffer Diagnostics (Trouble)" })

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
  map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
  map("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
end

-- Toggle options
local toggle = Snacks.toggle
toggle.option("spell", { name = "Spelling" }):map("<leader>us")
toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
toggle.diagnostics():map("<leader>ud")
toggle.line_number():map("<leader>ul")
toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
toggle.treesitter():map("<leader>uT")
toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
if vim.lsp.inlay_hint then
  toggle.inlay_hints():map("<leader>uh")
end

-- Fzf-lua
local fzf = require('fzf-lua')
local function searchBuf()
  fzf.buffers { sort_mru = true, sort_lastused = true }
end

map('n', '<leader>so', fzf.builtin, { desc = '[S]earch [O]pen' })
map('n', 'gd', function() fzf.lsp_definitions { jump_to_single_result = true } end, { desc = '[G]oto [D]efinition' })
map('n', 'gr', function() fzf.lsp_references { jump_to_single_result = true } end, { desc = '[G]oto [R]eferences' })
map('n', 'gI', function() fzf.lsp_implementations { jump_to_single_result = true } end, { desc = '[G]oto [I]mplementation' })
map('n', 'gy', function() fzf.lsp_typedefs { jump_to_single_result = true } end, { desc = '[G]oto [Y]pe Definition' })
map('n', '<leader>cs', function() fzf.lsp_document_symbols { jump_to_single_result = true } end, { desc = '[C]ode [S]ymbols' })
map('n', '<leader>cD', function() fzf.lsp_document_diagnostics { jump_to_single_result = true } end, { desc = '[C]ode [D]iagnostics' })
map('n', '<leader>ca', function() fzf.lsp_code_actions { jump_to_single_result = true } end, { desc = '[C]ode [A]ctions' })
map('n', '<leader>ss', function() fzf.lsp_workspace_symbols { jump_to_single_result = true } end, { desc = '[S]earch [S]ymbols' })
map('n', '<leader>sd', function() fzf.lsp_workspace_diagnostics { jump_to_single_result = true } end, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sS', function() fzf.lsp_live_workspace_symbols { jump_to_single_result = true } end, { desc = '[S]earch [W]orkspace Symbols' })
map('n', '<leader>s/', fzf.live_grep, { desc = '[S]earch [G]rep' })
map('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
map('n', '<leader>s"', fzf.registers, { desc = '[S]earch [R]egisters' })
map('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>sj', fzf.jumps, { desc = '[S]earch [J]umplist' })
map('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sl', fzf.loclist, { desc = '[S]earch [L]ocation list' })
map('n', '<leader>sm', fzf.marks, { desc = '[S]earch [M]arks' })
map('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
map('n', '<leader>sC', fzf.command_history, { desc = '[S]earch [C]ommand [H]istory' })
map('n', '<leader>sg', fzf.git_status, { desc = '[S]earch [G]it [S]tatus' })
map('n', '<leader>sgc', fzf.git_commits, { desc = '[S]earch [G]it [C]ommits' })
map('n', '<leader>sgb', fzf.git_branches, { desc = '[S]earch [G]it [B]ranches' })
map('n', '<leader>sb', searchBuf, { desc = 'Search [B]uffers' })
map('n', '<leader>sO', fzf.oldfiles, { desc = 'Search [O]ldfiles' })
map('n', '<leader>f', fzf.files, { desc = 'Search Files' })
map('n', '<leader><space>', searchBuf, { desc = 'Search Buffers' })
map('n', '<leader>/', fzf.lgrep_curbuf, { desc = 'Search current Buffer' })


-- Neovide fullscreen toggle
if vim.g.neovide then
  map('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
end

-- Which-key groups
require('which-key').add {
  { '<leader>c', group = 'Code' },
  { '<leader>g', group = 'Git' },
  { '<leader>s', group = 'Search' },
  { '<leader>b', group = 'Buffer' },
  { '<leader>u', group = 'UI Toggle' },
  { '<leader>w', group = 'Workspace' },
  { '<leader>q', group = 'Project' },
  { '<leader>a', group = 'AI'}
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = '*',
})

-- vim: ts=2 sts=2 sw=2 et
