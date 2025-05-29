local mason_registry = require 'mason-registry'
local vue_package_path = vim.fn.expand("$MASON/packages/vue-language-server")
local ts_package_path = vim.fn.expand("$MASON/packages/typescript-language-server")
local ts_language_path = ts_package_path .. '/node_modules/typescript'
local vue_language_server_path = vue_package_path .. '/node_modules/@vue/language-server'
local vue_ts_path = vue_package_path .. '/node_modules/typescript'

-- @type lspconfig.options
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },

  vue_ls = {
    formatting = false,
    -- capabilities = {
    --   workspace = {
    --     -- make volar auto reload
    --     didChangeWatchedFiles = {
    --       dynamicRegistration = true,
    --     },
    --   },
    -- },
    init_options = {
      vue = {
        hybridMode = true,
        typescript = {
          tsdk = vue_ts_path, -- delete this will use project ts version
        },
      },
    },
  },

  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
        keyOrdering = false,
      },
    },
  },

  ts_ls = {
    enabled = false,
    filetypes = {},
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue' },
        },
      },
    },
  },

  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },

  vtsls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      'vue'
    },
    settings = {
      formatting = false,
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = false, -- just use vtsls built-in tsdk
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true, -- allow workspace typescipt load vue plugin
            },
          }
        }
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  },
  clangd = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    cmd = {
      "clangd",
      "--background-index",            -- 在后台自动分析文件
      "--clang-tidy",                  -- 启用 Clang-Tidy 以提供「静态检查」
      "--header-insertion=iwyu",       -- 允许补充头文件
      "--completion-style=detailed",   --
      "--function-arg-placeholders",   -- 启用这项时，补全函数时，将会给参数提供占位符，键入后按 Tab 可以切换到下一占位符，乃至函数末
      "--fallback-style=llvm",         -- 默认格式化风格: llvm
      "--pretty",                      -- 输出的 JSON 文件更美观
      "--all-scopes-completion",       --  全局补全(输入时弹出的建议将会提供 CMakeLists.txt 里配置的所有文件中可能的符号，会自动补充头文件)
      "--cross-file-rename",           -- 跨文件重命名变量
      "--header-insertion-decorators", -- 输入建议中，已包含头文件的项与还未包含头文件的项会以圆点加以区分
      "-j=8",                          -- 同时开启的任务数量
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  }
}

-- if #vim.fs.find({ 'App.vue' }, { limit = 1 }) > 0 then
--   servers.tsserver.autostart = false
--   servers.volar.filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
-- end

local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, {
  -- 'stylua', -- Used to format Lua code
  'clangd',
  'cssls',
  'html',
  'marksman',
  -- 'prettier',
  'rust_analyzer',
  'glsl_analyzer',
})

return {
  ensure_installed = ensure_installed,
  servers = servers
}
