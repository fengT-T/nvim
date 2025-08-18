local function get_key(filename, match)
  local content = vim.fn.readfile(filename) -- 读取文件内容到列表
  for _, line in ipairs(content) do
    local key = line:match(match)           -- 更简洁的模式匹配
    if key then return key end
  end
  return nil, '未找到 deepseek 密钥'
end

local ai_list = {
  minuet = {
    'milanglacier/minuet-ai.nvim',
    opts = {
      provider = 'openai_fim_compatible',
      provider_options = {
        openai_fim_compatible = {
          end_point = 'https://api.siliconflow.cn/v1/completions',
          api_key = function()
            return get_key('/home/feng/.aider.conf.yml', "openai%-api%-key:%s*['\"]?([%w%-_]+)['\"]?")
          end,
          model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
          name = ' ',
          optional = {
            max_tokens = 512,
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
  aider = {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    -- Example key mappings for common actions:
    keys = {
      { "<leader>a/", "<cmd>Aider toggle<cr>",       desc = "Toggle Aider" },
      { "<leader>as", "<cmd>Aider send<cr>",         desc = "Send to Aider",                  mode = { "n", "v" } },
      { "<leader>ac", "<cmd>Aider command<cr>",      desc = "Aider Commands" },
      { "<leader>ab", "<cmd>Aider buffer<cr>",       desc = "Send Buffer" },
      { "<leader>a+", "<cmd>Aider add<cr>",          desc = "Add File" },
      { "<leader>a-", "<cmd>Aider drop<cr>",         desc = "Drop File" },
      { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
      { "<leader>aR", "<cmd>Aider reset<cr>",        desc = "Reset Session" },
      -- Example nvim-tree.lua integration if needed
      { "<leader>a+", "<cmd>AiderTreeAddFile<cr>",   desc = "Add File from Tree to Aider",    ft = "NvimTree" },
      { "<leader>a-", "<cmd>AiderTreeDropFile<cr>",  desc = "Drop File from Tree from Aider", ft = "NvimTree" },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      win = {
        position = "float"
      }
    }
    -- config = true,
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
        qwen3 = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              -- api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
              api_key = function()
                return get_key('/home/feng/.aider.conf.yml', "openai%-api%-key:%s*['\"]?([%w%-_]+)['\"]?")
              end,
              url = "https://dashscope.aliyuncs.com/compatible-mode"
            },
            schema = {
              model = {
                default = "qwen3-coder-480b-a35b-instruct"
              }
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "qwen3",
        },
        inline = {
          adapter = "qwen3",
        },
        cmd = {
          adapter = "qwen3",
        }
      }
    },
  },
}

return { ai_list.aider, ai_list.minuet, ai_list.cc }
