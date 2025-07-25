return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      'default',
      fzf_colors = true,
      lsp = {
        code_actions = {
          previewer = "codeaction_native",
          winopts = {
            -- 关键：设置垂直布局（上下分割）
            preview = {
              layout = 'vertical', -- 垂直布局（上下分割）
              vertical = 'up:70%', -- 预览窗口在上方，占65%高度（可调整比例）
              -- vertical = 'down:40%',     -- 或放在下方
              scrollbar = 'false' -- 可选的滚动条设置
            }
          }
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
