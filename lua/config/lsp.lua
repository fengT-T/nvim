local M = {}

local diagnostics_icon = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
function M.setup()
  require("mason").setup()
  local vue_package_path = vim.fn.expand('$MASON/packages/vue-language-server')
  local vue_language_server_path = vue_package_path .. '/node_modules/@vue/language-server'

  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },

    vue_ls = {},

    yamlls = {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          schemas = require('schemastore').yaml.schemas(),
          keyOrdering = false,
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
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
      },
      settings = {
        formatting = false,
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = false,
          experimental = { completion = { enableServerSideFuzzyMatch = true } },
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
                configNamespace = 'typescript',
                enableForWorkspaceTypeScriptVersions = true,
              },
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = 'always' },
          suggest = { completeFunctionCalls = true },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    },

    clangd = {
      capabilities = { offsetEncoding = { 'utf-16' } },
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
        '--pretty',
        '--all-scopes-completion',
        '--cross-file-rename',
        '--header-insertion-decorators',
        '-j=8',
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    },

    neocmake = {
      init_options = {
        format = { enable = true },
        lint = { enable = true },
        scan_cmake_in_package = true,
      },
    },
  }

  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, {
    'clangd',
    'cssls',
    'html',
    'marksman',
    'rust_analyzer',
    'glsl_analyzer',
  })

  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = diagnostics_icon.Error,
        [vim.diagnostic.severity.WARN] = diagnostics_icon.Warn,
        [vim.diagnostic.severity.INFO] = diagnostics_icon.Info,
        [vim.diagnostic.severity.HINT] = diagnostics_icon.Hint,
      },
    },
    virtual_text = {
      prefix = function(diagnostic)
        for d, icon in pairs(diagnostics_icon) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
        return '●'
      end,
    },
  })

  Snacks.util.lsp.on({ method = "textDocument/completion" }, function(buf, client)
    if client.name ~= 'glsl_analyzer' then
      client.server_capabilities.completionProvider.triggerCharacters =
          vim.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.", "")
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    else
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = false })
    end
  end)

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "glsl_analyzer" then
        client.cancel_request = function() end
      end
    end,
  })

  Snacks.util.lsp.on({ method = 'textDocument/foldingRange' }, function()
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end)

  Snacks.util.lsp.on({ method = 'textDocument/inlayHint' }, function(buf)
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end)

  Snacks.util.lsp.on({ method = 'textDocument/codeLens' }, function(buf)
    vim.lsp.codelens.enable(true)
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = buf,
      callback = function()
        vim.lsp.codelens.enable(true)
      end,
    })
  end)

  require('mason').setup()
  -- local capabilities = require('blink.cmp').get_lsp_capabilities()
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    automatic_enable = true,
    automatic_installation = true,
    ensure_installed = ensure_installed,
  })

  for server_name, config in pairs(servers) do
    config.capabilities = vim.tbl_deep_extend('force', {}, config.capabilities or {})
    vim.lsp.config(server_name, config)
  end

  require('clangd_extensions').setup({
    inlay_hints = { inline = false },
    ast = {
      role_icons = {
        type = '',
        declaration = '',
        expression = '',
        specifier = '',
        statement = '',
        ['template argument'] = '',
      },
      kind_icons = {
        Compound = '',
        Recovery = '',
        TranslationUnit = '',
        PackExpansion = '',
        TemplateTypeParm = '',
        TemplateTemplateParm = '',
        TemplateParamObject = '',
      },
    },
  })

  -- lsp_keymaps()

  local loaded = false
  local function check_cmake()
    local cwd = vim.uv.cwd()
    if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
      vim.cmd.packadd('cmake-tools.nvim')
      require('cmake-tools').setup({
        cmake_build_directory = function()
          local osys = require('cmake-tools.osys')
          if osys.iswin32 then return 'build\\${variant:buildType}' end
          return 'build/${variant:buildType}'
        end,
      })
      loaded = true
    end
  end
  check_cmake()
  vim.api.nvim_create_autocmd('DirChanged', {
    callback = function()
      if not loaded then check_cmake() end
    end,
  })
  -- require("fidget").setup({})
end

function M.cmp()
  require('blink.cmp').setup({
    keymap = { preset = 'default' },
    fuzzy = { sorts = { 'score', 'sort_text', 'label' } },
    signature = { enabled = true },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = { winblend = 10, draw = { treesitter = { 'lsp' } } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = true },
    },
    cmdline = { enabled = false },
  })
end

return M
