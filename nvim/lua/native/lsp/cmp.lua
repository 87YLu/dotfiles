-- https://github.com/hrsh7th/nvim-cmp
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    local cmp_keys = require('native.basic.keymaps').cmp

    local cmp_info_style = cmp.config.window.bordered({
      border = 'rounded',
    })

    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,preview,noselect',
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol',
          maxwidth = 50,
          ellipsis_char = '...',
          show_labelDetails = true,

          before = function(entry, vim_item)
            return vim_item
          end,
        }),
      },
      window = {
        completion = cmp_info_style,
        documentation = cmp_info_style,
      },
      mapping = cmp.mapping.preset.insert({
        [cmp_keys.c_next] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { 'i', 's' }),
        [cmp_keys.c_prev] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    require('luasnip.loaders.from_vscode').load({
      paths = { '~/.config/nvim/lua/lsp/snippets' },
    })

    local ls = require('luasnip')

    -- 片段参数前后跳转
    vim.keymap.set({ 'i', 's' }, cmp_keys.p_prev, function()
      ls.jump(-1)
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, cmp_keys.p_next, function()
      ls.jump(1)
    end, { silent = true })
  end,
}
