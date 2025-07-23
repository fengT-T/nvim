return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      'default',
      fzf_colors = true,
      lsp = {
        code_actions = {
          previewer = "codeaction_native"
        },
      },
      files = {
        formatter = "path.filename_first"
      },
      winopts = {
        preview = {
          horizontal = "right:50%"
        }
      }

    },
    init = function()
      require("fzf-lua").register_ui_select()
    end
  }
}
