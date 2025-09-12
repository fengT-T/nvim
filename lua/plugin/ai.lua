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
      provider = 'openai_fim_compatible',
      provider_options = {
        openai_fim_compatible = {
          end_point = 'https://api.siliconflow.cn/v1/completions',
          api_key = openai_key,
          model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
          name = ' ',
          optional = {
            max_tokens = 131072,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = {},
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
      language = "Chinese",
      adapters = {
        http = {
          siliconflow = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                api_key = openai_key(),
                url = "https://api.siliconflow.cn"
              },
              schema = {
                model = {
                  default = "zai-org/GLM-4.5"
                }
              },
            })
          end,
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                ANTHROPIC_BASE_URL = "https://open.bigmodel.cn/api/anthropic",
                ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY"
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = {
            name = "siliconflow",
            model = "Qwen/Qwen3-30B-A3B-Instruct-2507"
          }
        },
        cmd = {
          adapter = {
            name = "siliconflow",
            model = "Qwen/Qwen3-30B-A3B-Instruct-2507"
          }
        }
      }
    },
  },
}

return { ai_list.minuet, ai_list.cc }
