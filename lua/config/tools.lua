local M = {}

function M.snacks()
  local dashboard = {
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
      header = [[
███╗   ██╗██╗   ██╗ █████╗       ██╗   ██╗██╗███╗   ███╗
████╗  ██║╚██╗ ██╔╝██╔══██╗      ██║   ██║██║████╗ ████║
██╔██╗ ██║ ╚████╔╝ ███████║█████╗██║   ██║██║██╔████╔██║
██║╚██╗██║  ╚██╔╝  ██╔══██║╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║   ██║   ██║  ██║       ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
    },
    sections = {
      { section = 'header' },
      { section = 'keys',  gap = 1, padding = 1 },
    },
  }

  require('snacks').setup({
    bufdelete = { enabled = true },
    input = { enabled = true },
    bigfile = { enabled = true },
    dashboard = dashboard,
    lazygit = { enabled = true },
    indent = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    notifier = { enabled = true },
    notify = { enabled = true },
    terminal = { enabled = true },
    picker = { enabled = false },
    explorer = { enabled = false },
    words = { enabled = true },
  })
end

function M.ai()
  local function get_key(filename, match)
    local content = vim.fn.readfile(filename)
    for _, line in ipairs(content) do
      local key = line:match(match)
      if key then return key end
    end
    return nil, '未找到密钥'
  end

  local function openai_key()
    return get_key('/home/feng/.aider.conf.yml', "openai%-api%-key:%s*['\"]?([%w%-_]+)['\"]?")
  end

  require('codecompanion').setup({
    opts = { language = 'Chinese' },
    adapters = {
      http = {
        ppio = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = { api_key = openai_key() },
            url = 'https://api.ppio.com/openai/v1/chat/completions',
            schema = { model = { default = 'zai-org/glm-5' } },
          })
        end,
      },
    },
    strategies = {
      chat = { adapter = 'ppio' },
      inline = { adapter = { name = 'ppio', model = 'zai-org/glm-5' } },
      cmd = { adapter = { name = 'ppio', model = 'zai-org/glm-5' } },
    },
  })
end

function M.formatting()
  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      vue = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
    },
    formatters = {},
  })
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

function M.fzf()
  require('fzf-lua').setup({
    'default',
    fzf_colors = true,
    lsp = {
      code_actions = {
        previewer = 'codeaction_native',
        winopts = {
          preview = {
            layout = 'vertical',
            vertical = 'up:70%',
            scrollbar = 'false',
          },
        },
      },
    },
    files = { formatter = 'path.filename_first' },
    winopts = { preview = { horizontal = 'right:50%' } },
  })
  require('fzf-lua').register_ui_select()
end

function M.flash()
  require('flash').setup()
end

return M
