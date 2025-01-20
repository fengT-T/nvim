return {
  aider = {
    "joshuavial/aider.nvim",
    opts = {
      auto_manage_context = true, -- automatically manage buffer context
      default_bindings = false,  -- use default <leader>A keybindings
      debug = false,            -- enable debug logging
    },
  },
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
    "Exafunction/codeium.nvim",
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
        auto_trigger = true,
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
  }
}
