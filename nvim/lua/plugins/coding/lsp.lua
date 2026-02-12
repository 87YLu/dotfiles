return {
  {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      'mason.nvim',
      'nvimdev/lspsaga.nvim',
      { 'mason-org/mason-lspconfig.nvim', config = function() end },
    },
    opts_extend = { 'servers.*.keys' },
    opts = {
      diagnostics = {
        underline = Utils.NvimConfig.get('lsp_underline', true),
        update_in_insert = false,
        virtual_text = Utils.NvimConfig.get('virtual_text', true) and VirtualText or false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = Icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = Icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = Icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = Utils.NvimConfig.get('inlay_hint', true),
        exclude = {},
      },
      folds = {
        enabled = true,
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      codelens = {
        enabled = false,
      },
      servers = {
        vue_ls = {},
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
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = Utils.Path.get_pkg_path('vue-language-server', '/node_modules/@vue/language-server'),
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = {
                completeFunctionCalls = true,
              },
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
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
            },
          },
        },
        rust_analyzer = {},
        cssls = {},
        html = {},
        jsonls = {},
        marksman = {},
      },
      setup = {},
    },
    config = vim.schedule_wrap(function(_, opts)
      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = 'textDocument/inlayHint' }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ''
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = 'textDocument/foldingRange' }, function()
          if Utils.set_default('foldmethod', 'expr') then
            Utils.set_default('foldexpr', 'v:lua.vim.lsp.foldexpr()')
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = 'textDocument/codeLens' }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.capabilities then
        opts.servers['*'] = vim.tbl_deep_extend('force', opts.servers['*'] or {}, {
          capabilities = opts.capabilities,
        })
      end

      if opts.servers['*'] then
        vim.lsp.config('*', opts.servers['*'])
      end

      -- get all the servers that are available through mason-lspconfig
      local mason_all = vim.tbl_keys(require('mason-lspconfig.mappings').get_mason_map().lspconfig_to_package)
      local mason_exclude = {}

      local function configure(server)
        if server == '*' then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup['*']
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))

      require('mason-lspconfig').setup({
        ensure_installed = install,
        automatic_enable = { exclude = mason_exclude },
      })

      -- lsp saga
      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          code_action = Icons.diagnostics.Hint,
        },
        lightbulb = {
          virtual_text = false,
        },
        symbol_in_winbar = {
          -- in lualine
          enable = false,
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local opts = function(desc)
            return { buffer = ev.buf, desc = desc }
          end
          local lspKeys = PluginsKeyMapping.LspSaga

          vim.keymap.set(
            'n',
            lspKeys.prevDiagnostic.key,
            '<cmd>Lspsaga diagnostic_jump_prev<CR>',
            opts(lspKeys.prevDiagnostic.desc)
          )
          vim.keymap.set(
            'n',
            lspKeys.nextDiagnostic.key,
            '<cmd>Lspsaga diagnostic_jump_next<CR>',
            opts(lspKeys.nextDiagnostic.desc)
          )
          vim.keymap.set('n', lspKeys.prevError.key, function()
            require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })
          end, opts(lspKeys.prevError.desc))
          vim.keymap.set('n', lspKeys.nextError.key, function()
            require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })
          end, opts(lspKeys.nextError.desc))
          vim.keymap.set('n', lspKeys.prevWarning.key, function()
            require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.WARN })
          end, opts(lspKeys.prevWarning.desc))
          vim.keymap.set('n', lspKeys.nextWarning.key, function()
            require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.WARN })
          end, opts(lspKeys.nextWarning.desc))
          vim.keymap.set('n', lspKeys.outline.key, '<cmd>Lspsaga outline<CR>', opts(lspKeys.outline.desc))
          vim.keymap.set('n', lspKeys.hoverDoc.key, '<cmd>Lspsaga hover_doc<CR>', opts(lspKeys.hoverDoc.desc))
          vim.keymap.set('n', lspKeys.rename.key, '<cmd>Lspsaga rename<CR>', opts(lspKeys.rename.desc))
          vim.keymap.set('n', lspKeys.finder.key, '<cmd>Lspsaga finder<CR>', opts(lspKeys.finder.desc))
          vim.keymap.set(
            { 'n', 'v' },
            lspKeys.codeAction.key,
            '<cmd>Lspsaga code_action<CR>',
            opts(lspKeys.codeAction.desc)
          )
          vim.keymap.set(
            'n',
            lspKeys.peekDefinition.key,
            '<cmd>Lspsaga peek_definition<CR>',
            opts(lspKeys.peekDefinition.desc)
          )
          vim.keymap.set(
            'n',
            lspKeys.gotoDefinition.key,
            '<cmd>Lspsaga goto_definition<CR>',
            opts(lspKeys.gotoDefinition.desc)
          )
          vim.keymap.set(
            'n',
            lspKeys.peekTypeDefinition.key,
            '<cmd>Lspsaga peek_type_definition<CR>',
            opts(lspKeys.peekTypeDefinition.desc)
          )
          vim.keymap.set(
            'n',
            lspKeys.gotoTypeDefinition.key,
            '<cmd>Lspsaga goto_type_definition<CR>',
            opts(lspKeys.gotoTypeDefinition.desc)
          )
        end,
      })
    end),
  },
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    keys = { { PluginsKeyMapping.Mason.key, '<cmd>Mason<cr>', desc = PluginsKeyMapping.Mason.desc } },
    build = ':MasonUpdate',
    opts_extend = { 'ensure_installed' },
    opts = {
      ensure_installed = {},
      ui = { border = 'rounded' },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      mr:on('package:install:success', function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require('lazy.core.handler.event').trigger({
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
