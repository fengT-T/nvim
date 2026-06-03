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
  require('codecompanion').setup({
    opts = { language = 'Chinese' },
    adapters = {
      http = {
        gpt = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = { api_key = "ZHUIYI_API_KEY" },
            url = 'https://newapi.ibot.ai/v1',
            schema = { model = { default = 'gpt-5.5' } },
          })
        end,
      },
      acp = {
        omp = function()
          local helpers = require("codecompanion.adapters.acp.helpers")
          return {
            name = "omp",
            formatted_name = "omp",
            type = "acp",
            roles = {
              llm = "assistant",
              user = "user",
            },
            commands = {
              default = {
                "omp",
                "acp"
              },
            },
            defaults = {
              mcpServers = {},
              timeout = 20000, -- 20 seconds
            },
            parameters = {
              protocolVersion = 1,
              clientCapabilities = {
                fs = { readTextFile = true, writeTextFile = true },
              },
              clientInfo = {
                name = "CodeCompanion.nvim",
                version = "1.0.0",
              },
            },
            handlers = {
              setup = function(self)
                return true
              end,
              auth = function(self)
                return true
              end,
              form_messages = function(self, messages, capabilities)
                return helpers.form_messages(self, messages, capabilities)
              end,
              on_exit = function(self, code) end,
            },
          }
        end,
      },
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
