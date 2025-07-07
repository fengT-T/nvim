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
      }
    },
    init = function()
      require("fzf-lua").register_ui_select()
    end
  }
}
