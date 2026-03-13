local function get_key(filename, match)
  local content = vim.fn.readfile(filename) -- 读取文件内容到列表
  for _, line in ipairs(content) do
    local key = line:match(match)           -- 更简洁的模式匹配
    if key then return key end
  end
  return nil, '未找到 deepseek 密钥'
end
local function openai_key()
  return get_key('/home/feng/.aider.conf.yml', "openai%-api%-key:%s*['\"]?([%w%-_]+)['\"]?")
end

local ai_list = {
  minuet = {
    'milanglacier/minuet-ai.nvim',
    opts = {
      provider = 'openai_compatible',
      provider_options = {
        openai_compatible = {
          end_point = 'https://api.ppio.com/openai/v1/chat/completions',
          api_key = openai_key,
          model = "deepseek/deepseek-v3.2",
          name = ' ',
          stream = true,
          optional = {
            -- reasoning_effort = 'none',
            -- max_tokens = 131072,
            -- top_p = 0.9,
          },
        },
      },
      debounce = 5000,
      virtualtext = {
        auto_trigger_ft = {
          '*'
        },
        keymap = {
          -- accept whole completion
          accept = '<A-y>',
          -- accept one line
          accept_line = '<A-a>',
          -- accept n lines (prompts for number)
          -- e.g. "A-z 2 CR" will accept 2 lines
          accept_n_lines = '<A-z>',
          -- Cycle to prev completion item, or manually invoke completion
          prev = '<A-[>',
          -- Cycle to next completion item, or manually invoke completion
          next = '<A-]>',
          dismiss = '<A-e>',
        },
      },
    }
  },
  cc = {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      opts = {
        language = "Chinese",
      },
      -- memory = {
      --   opts = {
      --     chat = {
      --       enabled = true
      --     }
      --   }
      -- },
      adapters = {
        http = {
          ppio = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                api_key = openai_key(),
              },
              url = "https://api.ppio.com/openai/v1/chat/completions",
              schema = {
                model = {
                  default = "zai-org/glm-5"
                }
              },
            })
          end,
        },
        -- acp = {
        --   claude_code = function()
        --     return require("codecompanion.adapters").extend("claude_code", {
        --       env = {
        --         ANTHROPIC_BASE_URL = "https://open.bigmodel.cn/api/anthropic",
        --         ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY"
        --       },
        --     })
        --   end,
        -- },
      },
      strategies = {
        chat = {
          adapter = "ppio",
        },
        inline = {
          adapter = {
            name = "ppio",
            model = "zai-org/glm-5"
          }
        },
        cmd = {
          adapter = {
            name = "ppio",
            model = "zai-org/glm-5"
          }
        }
      }
    },
  },
}

return { ai_list.cc }
