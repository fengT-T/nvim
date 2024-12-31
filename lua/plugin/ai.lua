return {
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
        idle_delay = 1000,
        key_bindings = {
          accept = "<Tab>",
          accept_word = false,
          accept_line = false,
          clear = "<C-]>",
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
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-}>",
          prev = "<M-{>",
          dismiss = "<C-}>"
        },
      }
    }
  }
}
