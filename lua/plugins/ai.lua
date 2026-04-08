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

return {
  -- {
  --   'milanglacier/minuet-ai.nvim',
  --   opts = {
  --     provider = 'openai_compatible',
  --     provider_options = {
  --       openai_compatible = {
  --         end_point = 'https://api.ppio.com/openai/v1/chat/completions',
  --         api_key = openai_key,
  --         model = 'deepseek/deepseek-v3.2',
  --         name = ' ',
  --         stream = true,
  --       },
  --     },
  --     debounce = 5000,
  --     virtualtext = {
  --       auto_trigger_ft = { '*' },
  --       keymap = {
  --         accept = '<A-y>',
  --         accept_line = '<A-a>',
  --         accept_n_lines = '<A-z>',
  --         prev = '<A-[>',
  --         next = '<A-]>',
  --         dismiss = '<A-e>',
  --       },
  --     },
  --   },
  -- },

  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
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
    },
  },
}
