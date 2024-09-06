local mason_registry = require 'mason-registry'
local vue_package_path = mason_registry.get_package('vue-language-server'):get_install_path()
local vue_language_server_path = vue_package_path .. '/node_modules/@vue/language-server'
-- local vue_ts_path = vue_package_path .. '/node_modules/typescript'

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

  volar = {
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
        -- hybridMode = true,
        -- typescript = {
        --   tssdk = vue_ts_path, -- delete this will use project ts version
        -- },
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

  tsserver = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
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
