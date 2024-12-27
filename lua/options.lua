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

-- Enable highlighting of the current line
vim.o.cursorline = true

-- Hide * markup for bold and italic, but not markers with substitutions
vim.o.conceallevel = 2

-- Enable break indent
vim.o.breakindent = true

-- Number of spaces tabs count for
vim.o.tabstop = 2

-- Size of an indent
vim.o.shiftwidth = 2

-- Round indent
vim.o.shiftround = true

-- Use spaces for tabs
vim.o.expandtab = true

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
vim.o.completeopt = 'menu,menuone,noselect'

vim.o.jumpoptions = 'view'

-- Show some invisible characters (tabs...
vim.o.list = true

-- Popup blend
vim.o.pumblend = 10

-- Maximum number of entries in a popup
vim.o.pumheight = 10

-- Lines of context
vim.o.scrolloff = 5

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Put new windows below current
vim.o.splitbelow = true
vim.o.splitkeep = "screen"

vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- Minimum window width
vim.o.winminwidth = 5

vim.o.winblend = 20

vim.cmd.colorscheme 'catppuccin'
-- vim.cmd.colorscheme 'bluloco-light'
-- vim.cmd.colorscheme 'github_light_colorblind'

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldexpr = "v:lua.require'util'.foldexpr()"
  vim.opt.foldmethod = "expr"
  vim.opt.foldtext = ""
else
  vim.opt.foldmethod = "indent"
  vim.opt.foldtext = "v:lua.require'util'.foldtext()"
end

vim.opt.foldlevel = 99
-- vim.opt.foldlevel = 0
-- vim.opt.foldmethod = 'marker'
vim.opt.foldenable = true
vim.opt.fileformats = 'unix,dos'
vim.opt.termguicolors = true

vim.opt.guifont = 'CaskaydiaCove Nerd Font:h13'
--- neovide config
if vim.g.neovide then
  vim.opt.guifont = 'CaskaydiaCove Nerd Font:h13:e-subpixelantialias'
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_scroll_animation_far_lines = 1
  vim.g.neovide_padding_left = 5
  -- vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_hide_mouse_when_typing = false
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

vim.filetype.add({
  extension = {
    frag = "glsl",
    vert = "glsl",
  },
})
