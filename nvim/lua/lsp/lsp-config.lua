return {
  {
    -- https://github.com/folke/neodev.nvim
    'folke/neodev.nvim',
    lazy = true,
  },
  {
    'pmizio/typescript-tools.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
  },
  {
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'nvimdev/lspsaga.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      -- lua lsp
      require('neodev').setup({})

      -- ts lsp
      require('typescript-tools').setup({
        settings = {
          tsserver_file_preferences = {
            importModuleSpecifierPreference = 'non-relative',
          },
          tsserver_locale = 'zh-CN',
        },
      })

      local file_utils = require('utils.file')
      local typescript_tools_keys = require('basic.keymaps').typescript_tools
      local lsp_keys = require('basic.keymaps').lspsaga

      vim.g.keyset('n', typescript_tools_keys.typescript_action, function()
        if file_utils.is_current_in_types({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) then
          vim.cmd('TSToolsRemoveUnused sync')
          vim.cmd('TSToolsAddMissingImports sync')
          vim.cmd('TSToolsOrganizeImports sync')
        end
      end, { desc = 'typescript action' })

      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      local lsps = {
        rust_analyzer = {},
        cssls = {},
        html = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        marksman = {},
      }

      for name, config in pairs(lsps) do
        config.capabilities = capabilities
        lspconfig[name].setup(config)
      end

      require('lspsaga').setup({
        ui = {
          border = 'rounded',
        },
        lightbulb = {
          virtual_text = false,
        },
        symbol_in_winbar = {
          -- 在 lualine 中使用
          enable = false,
        },
      })

      local is_unknown_word_error = function(diagnostic)
        return diagnostic and diagnostic.source == 'cspell'
      end

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return is_unknown_word_error(diagnostic) and '' or diagnostic.message
          end,
          prefix = function(diagnostic)
            return is_unknown_word_error(diagnostic) and '' or '●'
          end,
        },
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = false,
      })

      local signs = { Error = ' ', Warn = ' ', Hint = '󰌵 ', Info = ' ' }

      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local opts = { buffer = ev.buf }

          vim.g.keyset('n', lsp_keys.diagnostic_jump_prev, '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
          vim.g.keyset('n', lsp_keys.diagnostic_jump_next, '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
          vim.g.keyset('n', lsp_keys.workspace_diagnostics, '<cmd>Lspsaga show_workspace_diagnostics ++float<CR>', opts)
          vim.g.keyset('n', lsp_keys.outline, '<cmd>Lspsaga outline<CR>', opts)
          vim.g.keyset('n', lsp_keys.peek_definition, '<cmd>Lspsaga peek_definition<CR>', opts)
          vim.g.keyset('n', lsp_keys.goto_definition, '<cmd>Lspsaga goto_definition<CR>', opts)
          vim.g.keyset('n', lsp_keys.hover_doc, '<cmd>Lspsaga hover_doc<CR>', opts)
          vim.g.keyset('n', lsp_keys.rename, '<cmd>Lspsaga rename<CR>', opts)
          vim.g.keyset({ 'n', 'v' }, lsp_keys.code_action, '<cmd>Lspsaga code_action<CR>', opts)
        end,
      })
    end,
  },
}
