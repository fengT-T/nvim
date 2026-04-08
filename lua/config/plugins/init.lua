local M = {}

local diagnostics_icon = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

function M.theme()
  require('catppuccin').setup({
    flavour = 'latte',
    color_overrides = {
      transparent_background = true,
      latte = { base = '#ffffff' },
    },
    term_colors = true,
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      indent_blankline = { enabled = true },
      lsp_trouble = true,
      mason = true,
      markdown = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
      neotest = true,
      snacks = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  })
  vim.cmd.colorscheme('catppuccin')
end

function M.ui()
  require('bufferline').setup({
    options = {
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and diagnostics_icon.Error .. diag.error .. ' ' or '')
            .. (diag.warning and diagnostics_icon.Warn .. diag.warning or '')
        return vim.trim(ret)
      end,
    },
  })

  require('lualine').setup({
    options = {
      theme = 'auto',
      globalstatus = true,
      disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
    },
    sections = {
      lualine_c = { 'filename', 'codecompainon' },
      lualine_x = { 'searchcount', 'encoding', 'fileformat', 'filetype' },
      lualine_z = { { 'datetime', style = '%I:%M %p' } },
    },
  })
end

function M.editor()
  require('Comment').setup()
  require('ts_context_commentstring').setup({ enable_autocmd = false })

  require('which-key').setup({ preset = 'helix' })

  require('mini.pairs').setup()
  require('nvim-surround').setup()

  require('persistence').setup({
    dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
  })

  require('marks').setup()

  require('trouble').setup({
    signs = {
      error = '',
      warning = '',
      hint = '',
      information = '',
      other = '',
    },
  })

  require('todo-comments').setup()

  require('render-markdown').setup({
    file_types = { 'markdown', 'codecompanion' },
  })

  require('glslView').setup({ viewer_path = 'glslviewer.exe' })
end

function M.git()
  local gs = package.loaded.gitsigns

  local function map(mode, l, r, opts)
    opts = opts or {}
    vim.keymap.set(mode, l, r, opts)
  end

  require('gitsigns').setup({
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    on_attach = function(bufnr)
      map({ 'n', 'v' }, ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Jump to next hunk' })

      map({ 'n', 'v' }, '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Jump to previous hunk' })

      map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'stage git hunk' })
      map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'reset git hunk' })
      map('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
      map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
      map('n', '<leader>gS', gs.stage_buffer, { desc = 'git Stage buffer' })
      map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
      map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
      map('n', '<leader>gp', gs.preview_hunk, { desc = 'preview git hunk' })
      map('n', '<leader>gb', function() gs.blame_line({ full = false }) end, { desc = 'git blame line' })
      map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
      map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'git diff against last commit' })
      map('n', '<leader>ub', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
      map('n', '<leader>ud', gs.toggle_deleted, { desc = 'toggle git show deleted' })
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
    end,
  })
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

function M.snacks()
  local dashboard = {
    preset = {
      header = [[
███╗   ██╗██╗   ██╗ █████╗       ██╗   ██╗██╗███╗   ███╗
████╗  ██║╚██╗ ██╔╝██╔══██╗      ██║   ██║██║████╗ ████║
██╔██╗ ██║ ╚████╔╝ ███████║█████╗██║   ██║██║██╔████╔██║
██║╚██╗██║  ╚██╔╝  ██╔══██║╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║   ██║   ██║  ██║       ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
    },
    sections = {
      { section = 'header' },
      { section = 'keys',  gap = 1, padding = 1 },
      -- { section = 'startup' },
    },
    -- Used by the `keys` section to show keymaps.
    -- Set your custom keymaps here.
    -- When using a function, the `items` argument are the default keymaps.
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  }

  require('snacks').setup({
    bufdelete = { enabled = true },
    input = { enabled = true },
    bigfile = { enabled = true },
    dashboard = dashboard,
    lazygit = { enabled = true },
    indent = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    notifier = { enabled = true },
    notify = { enabled = true },
    terminal = { enabled = true },
    picker = { enabled = false },
    explorer = { enabled = false },
    words = { enabled = true },
  })
end

local function lsp_keymaps()
  local map = Snacks.keymap.set

  map('n', 'gD', vim.lsp.buf.declaration, { lsp = {}, desc = 'Goto Declaration' })
  map('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'Hover' })
  map('n', 'gK', vim.lsp.buf.signature_help, { lsp = { method = 'textDocument/signatureHelp' }, desc = 'Signature Help' })
  map('i', '<c-k>', vim.lsp.buf.signature_help,
    { lsp = { method = 'textDocument/signatureHelp' }, desc = 'Signature Help' })

  map({ 'n', 'x' }, '<leader>cA', vim.lsp.buf.code_action,
    { lsp = { method = 'textDocument/codeAction' }, desc = 'Code Action' })
  map('n', '<leader>cr', vim.lsp.buf.rename, { lsp = { method = 'textDocument/rename' }, desc = 'Rename' })

  map('n', '<leader>cR', function() Snacks.rename.rename_file() end, {
    lsp = { method = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } },
    desc = 'Rename File',
  })

  map('n', '<leader>cc', vim.lsp.codelens.run, { lsp = { method = 'textDocument/codeLens' }, desc = 'Run Codelens' })
  map('n', '<leader>cC', function()
      vim.lsp.codelens.enable(true)
    end,
    { lsp = { method = 'textDocument/codeLens' }, desc = 'Refresh Codelens' })

  map('n', '<leader>co', function()
    vim.lsp.buf.code_action({
      context = {
        only = {
          'source.organizeImports',
        },
      },
      apply = true,
    })
  end, { lsp = { method = 'textDocument/codeAction' }, desc = 'Organize Imports' })

  map('n', '<M-n>', function() Snacks.words.jump(vim.v.count1) end, {
    lsp = { method = 'textDocument/documentHighlight' },
    desc = 'Next Reference',
  })
  map('n', '<M-p>', function() Snacks.words.jump(-vim.v.count1) end, {
    lsp = { method = 'textDocument/documentHighlight' },
    desc = 'Prev Reference',
  })

  map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
  map('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Diagnostics List' })

  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Workspace Add Folder' })
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Workspace Remove Folder' })
  map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = 'Workspace List Folders' })
end

function M.lsp()
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
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    automatic_enable = true,
    automatic_installation = true,
    ensure_installed = ensure_installed,
  })

  for server_name, config in pairs(servers) do
    config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
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

  lsp_keymaps()

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
  require("fidget").setup({})
end

function M.dap()
  local dap = require('dap')
  local dapui = require('dapui')

  if not dap.adapters['codelldb'] then
    dap.adapters['codelldb'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = { command = 'codelldb', args = { '--port', '${port}' } },
    }
  end

  for _, lang in ipairs({ 'c', 'cpp' }) do
    dap.configurations[lang] = {
      {
        type = 'codelldb',
        request = 'launch',
        name = 'Launch file',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
      },
      {
        type = 'codelldb',
        request = 'attach',
        name = 'Attach to process',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }
  end

  local function get_args(config)
    local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
    local args_str = type(args) == 'table' and table.concat(args, ' ') or args
    config = vim.deepcopy(config)
    config.args = function()
      local new_args = vim.fn.expand(vim.fn.input('Run with args: ', args_str))
      if config.type and config.type == 'java' then return new_args end
      return require('dap.utils').splitstr(new_args)
    end
    return config
  end

  vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    { desc = 'Breakpoint Condition' })
  vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = 'Run/Continue' })
  vim.keymap.set('n', '<leader>da', function() dap.continue({ before = get_args }) end, { desc = 'Run with Args' })
  vim.keymap.set('n', '<leader>dC', function() dap.run_to_cursor() end, { desc = 'Run to Cursor' })
  vim.keymap.set('n', '<leader>dg', function() dap.goto_() end, { desc = 'Go to Line (No Execute)' })
  vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = 'Step Into' })
  vim.keymap.set('n', '<leader>dj', function() dap.down() end, { desc = 'Down' })
  vim.keymap.set('n', '<leader>dk', function() dap.up() end, { desc = 'Up' })
  vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = 'Run Last' })
  vim.keymap.set('n', '<leader>do', function() dap.step_out() end, { desc = 'Step Out' })
  vim.keymap.set('n', '<leader>dO', function() dap.step_over() end, { desc = 'Step Over' })
  vim.keymap.set('n', '<leader>dP', function() dap.pause() end, { desc = 'Pause' })
  vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'Toggle REPL' })
  vim.keymap.set('n', '<leader>ds', function() dap.session() end, { desc = 'Session' })
  vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = 'Terminate' })
  vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  for name, sign in pairs({
    Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  }) do
    sign = type(sign) == 'table' and sign or { sign }
    vim.fn.sign_define('Dap' .. name, {
      text = sign[1],
      texthl = sign[2] or 'DiagnosticInfo',
      linehl = sign[3],
      numhl = sign[3]
    })
  end

  local vscode = require('dap.ext.vscode')
  local json = require('plenary.json')
  vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

  dapui.setup()
  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end

  vim.keymap.set('n', '<leader>du', function() dapui.toggle({}) end, { desc = 'Dap UI' })
  vim.keymap.set({ 'n', 'v' }, '<leader>de', function() dapui.eval() end, { desc = 'Eval' })

  require('mason-nvim-dap').setup({
    automatic_installation = true,
    handlers = {},
    ensure_installed = {},
  })

  require('nvim-dap-virtual-text').setup()
end

function M.ai()
  local function get_key(filename, match)
    local content = vim.fn.readfile(filename)
    for _, line in ipairs(content) do
      local key = line:match(match)
      if key then return key end
    end
    return nil, '未找到密钥'
  end

  local function openai_key()
    return get_key('/home/feng/.aider.conf.yml', "openai%-api%-key:%s*['\"]?([%w%-_]+)['\"]?")
  end

  require('codecompanion').setup({
    opts = { language = 'Chinese' },
    adapters = {
      http = {
        ppio = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = { api_key = openai_key() },
            url = 'https://api.ppio.com/openai/v1/chat/completions',
            schema = { model = { default = 'zai-org/glm-5' } },
          })
        end,
      },
    },
    strategies = {
      chat = { adapter = 'ppio' },
      inline = { adapter = { name = 'ppio', model = 'zai-org/glm-5' } },
      cmd = { adapter = { name = 'ppio', model = 'zai-org/glm-5' } },
    },
  })
end

function M.formatting()
  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      vue = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
    },
    format_on_save = false,
    formatters = {},
  })
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

function M.fzf()
  require('fzf-lua').setup({
    'default',
    fzf_colors = true,
    lsp = {
      code_actions = {
        previewer = 'codeaction_native',
        winopts = {
          preview = {
            layout = 'vertical',
            vertical = 'up:70%',
            scrollbar = 'false',
          },
        },
      },
    },
    files = { formatter = 'path.filename_first' },
    winopts = { preview = { horizontal = 'right:50%' } },
  })
  require('fzf-lua').register_ui_select()
end

function M.flash()
  require('flash').setup()

  vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
  vim.keymap.set({ 'n', 'o', 'x' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
  vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
  vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end,
    { desc = 'Treesitter Search' })
  vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
end

function M.treesitter()
  require('tree-sitter-manager').setup({})
end

return M
