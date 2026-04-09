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
map('n', '<leader>e', Snacks.explorer.open, { desc = 'Open file explorer' })
map('n', '<leader>E', Snacks.explorer.reveal, { desc = 'Find File explorer' })
-- map('n', '<leader>e', '<cmd>Yazi<cr>', { desc = 'yazi file explorer' })

-- Save
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Persistence
local persistence = require('persistence')
map('n', '<leader>qs', persistence.load, { desc = 'restore current session' })
map('n', '<leader>ql', function() persistence.load({ last = true }) end, { desc = 'restore last session' })
map('n', '<leader>qd', persistence.stop, { desc = 'stop persistence' })
map('n', '<leader>qS', persistence.select, { desc = 'stop persistence' })

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


map({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ccc CodeCompanionChat]])
vim.cmd([[cab cca CodeCompanionActions]])

map('n', '<leader>mr', '<cmd>CMakeRun<cr>', { desc = 'cmake run' })
map('n', '<leader>mb', '<cmd>CMakeBuildCurrentFile<cr>', { desc = 'cmake build' })

-- DAP
local dap = require('dap')
local dapui = require('dapui')
map('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = 'Breakpoint Condition' })
map('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
map('n', '<leader>dc', function() dap.continue() end, { desc = 'Run/Continue' })
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
  local args_str = type(args) == 'table' and table.concat(args, ' ') or args
  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input('Run with args: ', args_str))
    if config.type and config.type == 'java' then return new_args end
    return require('dap.utils').splitstr(new_args)
  end
  return config
end
map('n', '<leader>da', function() dap.continue({ before = get_args }) end, { desc = 'Run with Args' })
map('n', '<leader>dC', function() dap.run_to_cursor() end, { desc = 'Run to Cursor' })
map('n', '<leader>dg', function() dap.goto_() end, { desc = 'Go to Line (No Execute)' })
map('n', '<leader>di', function() dap.step_into() end, { desc = 'Step Into' })
map('n', '<leader>dj', function() dap.down() end, { desc = 'Down' })
map('n', '<leader>dk', function() dap.up() end, { desc = 'Up' })
map('n', '<leader>dl', function() dap.run_last() end, { desc = 'Run Last' })
map('n', '<leader>do', function() dap.step_out() end, { desc = 'Step Out' })
map('n', '<leader>dO', function() dap.step_over() end, { desc = 'Step Over' })
map('n', '<leader>dP', function() dap.pause() end, { desc = 'Pause' })
map('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'Toggle REPL' })
map('n', '<leader>ds', function() dap.session() end, { desc = 'Session' })
map('n', '<leader>dt', function() dap.terminate() end, { desc = 'Terminate' })
map('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })
map('n', '<leader>du', function() dapui.toggle({}) end, { desc = 'Dap UI' })
map({ 'n', 'v' }, '<leader>de', function() dapui.eval() end, { desc = 'Eval' })

-- Flash
map({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
map({ 'n', 'o', 'x' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
map('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
map({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
map('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })

-- Treesitter textobjects
local ts_move = require("nvim-treesitter-textobjects.move")
local ts_select = require('nvim-treesitter-textobjects.select')
-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
map({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end,
  { desc = "select outer function" })
map({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end,
  { desc = "select inner function" })
map({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end,
  { desc = "select class outer" })
map({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.outer", "textobjects") end,
  { desc = "select outer class" })
-- You can also use captures from other query groups like `locals.scm`
map({ "x", "o" }, "as", function() ts_select.select_textobject("@local.scope", "locals") end, { desc = "select local" })

-- keymaps
map("n", "<leader>oa", function()
  require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end, { desc = "swap inner parameter" })
map("n", "<leader>oA", function()
  require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
end, { desc = "swap outer parameter" })

map({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end,
  { desc = "Next function start" })
map({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.outer", "textobjects") end,
  { desc = "Next class start" })
map({ "n", "x", "o" }, "]o", function() ts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end,
  { desc = "Next loop start" })
map({ "n", "x", "o" }, "]s", function() ts_move.goto_next_start("@local.scope", "locals") end,
  { desc = "Next scope" })
map({ "n", "x", "o" }, "]z", function() ts_move.goto_next_start("@fold", "folds") end,
  { desc = "Next fold" })
map({ "n", "x", "o" }, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end,
  { desc = "Next function end" })
map({ "n", "x", "o" }, "][", function() ts_move.goto_next_end("@class.outer", "textobjects") end,
  { desc = "Next class end" })
map({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end,
  { desc = "Prev function start" })
map({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.outer", "textobjects") end,
  { desc = "Prev class start" })
map({ "n", "x", "o" }, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end,
  { desc = "Prev function end" })
map({ "n", "x", "o" }, "[]", function() ts_move.goto_previous_end("@class.outer", "textobjects") end,
  { desc = "Prev class end" })
map({ "n", "x", "o" }, "]c", function() ts_move.goto_next("@conditional.outer", "textobjects") end,
  { desc = "Next conditional" })
map({ "n", "x", "o" }, "[c", function() ts_move.goto_previous("@conditional.outer", "textobjects") end,
  { desc = "Prev conditional" })

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
  { '<leader>d', group = 'Debug' },
  { '<leader>o', group = 'Operate' },
  { '<leader>m', group = 'CMake' }
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = '*',
})
local function lsp_keymaps()
  local smap = Snacks.keymap.set

  smap('n', 'gD', vim.lsp.buf.declaration, { lsp = {}, desc = 'Goto Declaration' })
  smap('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'Hover' })
  smap('n', 'gK', vim.lsp.buf.signature_help,
    { lsp = { method = 'textDocument/signatureHelp' }, desc = 'Signature Help' })
  smap('i', '<c-k>', vim.lsp.buf.signature_help,
    { lsp = { method = 'textDocument/signatureHelp' }, desc = 'Signature Help' })

  smap({ 'n', 'x' }, '<leader>cA', vim.lsp.buf.code_action,
    { lsp = { method = 'textDocument/codeAction' }, desc = 'Code Action' })
  smap('n', '<leader>cr', vim.lsp.buf.rename, { lsp = { method = 'textDocument/rename' }, desc = 'Rename' })

  smap('n', '<leader>cR', function() Snacks.rename.rename_file() end, {
    lsp = { method = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } },
    desc = 'Rename File',
  })

  smap('n', '<leader>cc', vim.lsp.codelens.run, { lsp = { method = 'textDocument/codeLens' }, desc = 'Run Codelens' })
  smap('n', '<leader>cC', function()
      vim.lsp.codelens.enable(true)
    end,
    { lsp = { method = 'textDocument/codeLens' }, desc = 'Refresh Codelens' })

  smap('n', '<leader>co', function()
    vim.lsp.buf.code_action({
      context = {
        only = {
          'source.organizeImports',
        },
      },
      apply = true,
    })
  end, { lsp = { method = 'textDocument/codeAction' }, desc = 'Organize Imports' })

  smap('n', '<M-n>', function() Snacks.words.jump(vim.v.count1) end, {
    lsp = { method = 'textDocument/documentHighlight' },
    desc = 'Next Reference',
  })
  smap('n', '<M-p>', function() Snacks.words.jump(-vim.v.count1) end, {
    lsp = { method = 'textDocument/documentHighlight' },
    desc = 'Prev Reference',
  })

  smap('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
  smap('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Diagnostics List' })

  smap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Workspace Add Folder' })
  smap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Workspace Remove Folder' })
  smap('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = 'Workspace List Folders' })
end

lsp_keymaps()
-- vim: ts=2 sts=2 sw=2 et
