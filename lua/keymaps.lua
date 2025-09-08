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

-- diagnostic
local diagnostic_goto = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity })
  end
end
-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(1), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(-1), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(1, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(-1, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(1, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(-1, "WARN"), { desc = "Prev Warning" })
-- File tree
-- map('n', '<leader>e', Snacks.explorer.open, { desc = 'Open file explorer' })
-- map('n', '<leader>E', Snacks.explorer.reveal, { desc = 'Find File explorer' })
map('n', '<leader>e', '<cmd>Yazi<cr>', { desc = 'yazi file explorer' })

-- Save
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

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
map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = "LSP Definitions / references / ... (Trouble)" })
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
toggle.option("conceallevel",
  { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map(
  "<leader>uA")
toggle.treesitter():map("<leader>uT")
toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
if vim.lsp.inlay_hint then
  toggle.inlay_hints():map("<leader>uh")
end

-- snacks
-- Snacks.picker.sources.lsp_symbols.filter.default = true
-- map('n', "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
-- map('n', "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
-- map('n', "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
-- map('n', "<leader><space>", function() Snacks.picker.files() end, { desc = "Find Files" })
-- -- find
-- map('n', "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
-- map('n', "<leader>fc", function()
--     Snacks.picker.files({
--       finder = "files",
--       format = "file",
--       supports_live = true,
--       ---@diagnostic disable-next-line: assign-type-mismatch
--       cwd = vim.fn.stdpath("config")
--     })
--   end,
--   { desc = "Find Config File" })
-- map('n', "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
-- map('n', "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
-- map('n', "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
-- map('n', "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
--
-- -- git
-- map('n', "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git Log" })
-- map('n', "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
-- -- Grep
-- map('n', "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
-- map('n', "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
-- map('n', "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
-- map({ 'n', 'x' }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
-- -- search
-- map('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
-- map('n', "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
-- map('n', "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
-- map('n', "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
-- map('n', "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
-- map('n', "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
-- map('n', "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
-- map('n', "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
-- map('n', "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
-- map('n', "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
-- map('n', "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
-- map('n', "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
-- map('n', "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
-- map('n', "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
-- map('n', "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
-- map('n', "<leader>qp", function() Snacks.picker.projects() end, { desc = "Projects" })
-- map('n', "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end,
--   { desc = "Todo Comments" })
-- map('n', "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Tags" })
-- map('n', "<leader>su", function() Snacks.picker.undotree() end, { desc = "Undotree" })
-- map('n', "<leader>so", function() Snacks.picker.pick() end, { desc = "Snacks Picker" })
--
-- -- LSP
-- map('n', "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
-- map('n', "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
-- map('n', "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
-- map('n', "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
-- map('n', "<leader>ss", function()
--   ---@diagnostic disable-next-line: param-type-mismatch
--   Snacks.picker.lsp_symbols(Snacks.picker.sources.lsp_workspace_symbols)
-- end, { desc = "LSP Symbols" })
-- map('n', '<leader>cs', function() Snacks.picker.lsp_symbols() end, { desc = 'docuement [C]ode [S]ymbols' })

-- fzf-lua
local function searhBuf()
  require('fzf-lua').buffers { sort_mru = true, sort_lastused = true }
end

map('n', '<leader>so', require('fzf-lua').builtin, { desc = '[S]earch [O]pen' })
-- lsp
map('n', 'gd', require('fzf-lua').lsp_definitions, { desc = '[G]oto [D]efinition' })
map('n', 'gr', require('fzf-lua').lsp_references, { desc = '[G]oto [R]eferences' })
map('n', 'gI', require('fzf-lua').lsp_implementations, { desc = '[G]oto [I]mplementation' })
map('n', 'gy', require('fzf-lua').lsp_typedefs, { desc = '[G]oto [Y]pe Definition' })
map('n', '<leader>cs', require('fzf-lua').lsp_document_symbols, { desc = '[C]ode [S]ymbols' })
map('n', '<leader>ce', require('fzf-lua').diagnostics_document, { desc = '[C]ode Diagnostics [E]rror' })
map('n', '<leader>ca', require('fzf-lua').lsp_code_actions, { desc = '[C]ode [A]ctions' })

-- workspace lsp
map('n', '<leader>sS', require('fzf-lua').lsp_workspace_symbols, { desc = '[S]earch [S]ymbols' })
map('n', '<leader>sd', require('fzf-lua').lsp_workspace_diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>ss', require('fzf-lua').lsp_live_workspace_symbols,
  { desc = '[S]earch [W]orkspace Symbols' })

-- grep workspace word
map('n', '<leader>s/', require('fzf-lua').live_grep, { desc = '[S]earch [G]rep' })
map('n', '<leader>sw', require('fzf-lua').grep_cword, { desc = '[S]earch current [W]ord' })
map('n', '<leader>s"', require('fzf-lua').registers, { desc = '[S]earch [R]egisters' })
map('n', '<leader>sr', require('fzf-lua').resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>sj', require('fzf-lua').jumps, { desc = '[S]earch [J]umplist' })
map('n', '<leader>sk', require('fzf-lua').keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sl', require('fzf-lua').loclist, { desc = '[S]earch [L]ocation list' })
map('n', '<leader>sm', require('fzf-lua').marks, { desc = '[S]earch [M]arks' })
map('n', '<leader>sM', require('fzf-lua').manpages, { desc = '[S]earch [M]an pages' })
map('n', '<leader>sh', require('fzf-lua').help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sc', require('fzf-lua').commands, { desc = '[S]earch [C]ommands' })
map('n', '<leader>sC', require('fzf-lua').command_history, { desc = '[S]earch [C]ommand [H]istory' })
map('n', '<leader>sg', require('fzf-lua').git_status, { desc = '[S]earch [G]it [S]tatus' })
map('n', '<leader>sgc', require('fzf-lua').git_commits, { desc = '[S]earch [G]it [C]ommits' })
map('n', '<leader>sgb', require('fzf-lua').git_branches, { desc = '[S]earch [G]it [B]ranches' })

-- search workspace file
map('n', '<leader>sb', searhBuf, { desc = 'Search [B]uffers' })
map('n', '<leader>sO', require('fzf-lua').oldfiles, { desc = 'Search [O]ldfiles' })
map('n', '<leader><space>', require('fzf-lua').files, { desc = 'Search Files' })
map('n', '<leader>,', searhBuf, { desc = 'Search Buffers' })
map({ "n", "v", "i" }, "<C-x><C-f>", function() require("fzf-lua").complete_path() end,
  { silent = true, desc = "Fuzzy complete path" })

-- grep current buff
map('n', '<leader>/', require('fzf-lua').lgrep_curbuf, { desc = 'Search current Buffer' })

map("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

-- terminal
map('t', '<esc>', [[<C-\><C-n>]])
-- map('t', 'jk', [[<C-\><C-n>]])
map('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
map('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
map('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
map('t', '<C-l>', [[<Cmd>wincmd l<CR>]])

map('n', '<C-\\>', Snacks.terminal.toggle, { desc = 'Oen terminal' })
map('t', '<C-\\>', Snacks.terminal.toggle, { desc = 'Open terminal' })
map('n', '<leader>t', Snacks.terminal.open, { desc = 'Open terminal' })

-- Aider AI assistant
-- map('n', '<leader>a', function() Snacks.terminal.toggle("aider") end, { desc = 'Open Aider AI assistant' })

-- Neovide fullscreen toggle
if vim.g.neovide then
  map('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
end

-- 在所有窗口打开当前 buffer
map('n', '<leader>bA', function()
  vim.cmd.windo("edit " .. vim.fn.expand("%"))
end, { desc = 'Open current buffer in all windows' })

map('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Toggle Pin' })
map('n', '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Delete Non-Pinned Buffers' })
map('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Delete Other Buffers' })
map('n', '<leader>br', '<Cmd>BufferLineCloseRight<CR>', { desc = 'Delete Buffers to the Right' })
map('n', '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', { desc = 'Delete Buffers to the Left' })
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
map('n', '<leader>x', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
map('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })

-- Which-key groups
require('which-key').add {
  { '<leader>c', group = 'Code' },
  { '<leader>g', group = 'Git' },
  { '<leader>s', group = 'Search' },
  { '<leader>b', group = 'Buffer' },
  { '<leader>u', group = 'UI Toggle' },
  { '<leader>w', group = 'Workspace' },
  { '<leader>q', group = 'Project' },
  { '<leader>f', group = 'File' },
  { '<leader>a', group = 'AI' },
  { '<leader>d', group = 'Debug' }
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = '*',
})

-- vim: ts=2 sts=2 sw=2 et
