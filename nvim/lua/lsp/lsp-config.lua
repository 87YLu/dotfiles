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
      require('basic.keymaps').typescript_tools()

      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
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

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = false,
      })

      local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌵 ', Info = ' ' }

      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      require('basic.keymaps').lspsaga()
    end,
  },
}
