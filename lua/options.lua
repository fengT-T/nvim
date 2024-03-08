-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.opt.relativenumber = true
-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- vim: ts=2 sts=2 sw=2 et

vim.cmd.colorscheme 'catppuccin'

if vim.fn.has 'nvim-0.10' == 1 then
  vim.opt.smoothscroll = true
end

vim.opt.foldlevel = 0
vim.opt.foldmethod = 'marker'
vim.opt.foldenable = true
vim.opt.fileformats = 'unix,dos'
vim.opt.termguicolors = true

vim.opt.guifont = 'CaskaydiaCove Nerd Font:h13'
--- neovide config
if vim.g.neovide then
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_scroll_animation_far_lines = 1
  vim.g.neovide_padding_left = 2
  -- vim.g.neovide_transparency = 0.95
end

-- will hidden cmd line
vim.opt.cmdheight = 0
-- auto hide cmdline
vim.api.nvim_create_autocmd({ 'RecordingEnter' }, {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd({ 'RecordingLeave' }, {
  callback = function()
    vim.opt.cmdheight = 0
  end,
})
