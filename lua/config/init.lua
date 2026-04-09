local M = {}

local ui = require('config.plugins.ui')
local editor = require('config.plugins.editor')
local git = require('config.plugins.git')
local lsp = require('config.plugins.lsp')
local dap = require('config.plugins.dap')
local tools = require('config.plugins.tools')
local treesitter = require('config.plugins.treesitter')

M.theme = ui.theme
M.ui = ui.ui
M.editor = editor.setup
M.git = git.setup
M.cmp = lsp.cmp
M.lsp = lsp.setup
M.dap = dap.setup
M.snacks = tools.snacks
M.ai = tools.ai
M.formatting = tools.formatting
M.fzf = tools.fzf
M.flash = tools.flash
M.treesitter = treesitter.setup

return M
