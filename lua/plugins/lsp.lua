local mason_registry = require 'mason-registry'
local vue_package_path = vim.fn.expand('$MASON/packages/vue-language-server')
local ts_package_path = vim.fn.expand('$MASON/packages/typescript-language-server')
local vue_language_server_path = vue_package_path .. '/node_modules/@vue/language-server'



return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      { 'saghen/blink.cmp' },
      'b0o/schemastore.nvim',
    },
    config = function()
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

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
          nmap('<leader>ck', vim.lsp.buf.signature_help, 'Signature Documentation')
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help,
            { buffer = event.buf, desc = 'Signature Documentation' })

          nmap('<leader>cd', vim.diagnostic.open_float, '[C]ode [D]iagnostics')
          nmap('<leader>cq', vim.diagnostic.setloclist, 'Open diagnostics list')

          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
          end
        end,
      })

      local diagnostic_icon = require('util').diagnostics_icon
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_icon.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_icon.Warn,
            [vim.diagnostic.severity.INFO] = diagnostic_icon.Info,
            [vim.diagnostic.severity.HINT] = diagnostic_icon.Hint,
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "Error",
            [vim.diagnostic.severity.WARN] = "Warn",
            [vim.diagnostic.severity.INFO] = "Info",
            [vim.diagnostic.severity.HINT] = "Hint",
          },
        },
        virtual_text = {
          prefix = function(diagnostic)
            for d, icon in pairs(diagnostic_icon) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
            return "●"
          end
        }
      })

      require('mason').setup()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        automatic_enable = true,
        automatic_installation = true,
        ensure_installed = ensure_installed,
      }

      for server_name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        vim.lsp.config(server_name, config)
      end
    end,
  },

  {
    'p00f/clangd_extensions.nvim',
    opts = {
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
    },
  },

  {
    'Civitasv/cmake-tools.nvim',
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
          require('lazy').load({ plugins = { 'cmake-tools.nvim' } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd('DirChanged', {
        callback = function()
          if not loaded then check() end
        end,
      })
    end,
    opts = {
      cmake_build_directory = function()
        local osys = require('cmake-tools.osys')
        if osys.iswin32 then return 'build\\${variant:buildType}' end
        return 'build/${variant:buildType}'
      end,
    },
  },
}
