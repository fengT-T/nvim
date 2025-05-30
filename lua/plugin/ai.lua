local function get_key(filename, match)
  local content = vim.fn.readfile(filename) -- 读取文件内容到列表
  for _, line in ipairs(content) do
    local key = line:match(match)           -- 更简洁的模式匹配
    if key then return key end
  end
  return nil, '未找到 deepseek 密钥'
end

local ai_list = {
  supermaven = {
    {
      "supermaven-inc/supermaven-nvim",
      opts = {
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-l>",
          accept_word = "<C-j>",
        }
      },
    },
  },
  codeium = {
    "Exafunction/windsurf.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        manual = false,
        idle_delay = 70,
        key_bindings = {
          accept = "<Tab>",
          accept_word = false,
          accept_line = false,
          clear = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
        }
      }
    }
  },
  copilot = {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 1000,
        keymap = {
          accept = "<Tab>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-l>"
        },
      }
    }
  },
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
          model= "deepseek-ai/DeepSeek-V3",
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
  }
}

return { ai_list.minuet }
