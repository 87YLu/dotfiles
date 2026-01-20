local confirm = function(opts)
  local cmp = require('cmp')
  opts = vim.tbl_extend('force', {
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
  }, opts or {})
  return function(fallback)
    if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
      Utils.create_undo()
      if cmp.confirm(opts) then
        return
      end
    end
    return fallback()
  end
end

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
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

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
        format = function(entry, item)
          local icons = Icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end

          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }

          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
            end
          end

          return item
        end,
      },
      window = {
        completion = cmp_info_style,
        documentation = cmp_info_style,
      },
      mapping = cmp.mapping.preset.insert({
        [PluginsKeyMapping.Cmp.nextItem.key] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { 'i', 's' }),
        [PluginsKeyMapping.Cmp.prevItem.key] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end),
        ['<CR>'] = confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline({
        [PluginsKeyMapping.Cmp.nextItem.key] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
        },
        [PluginsKeyMapping.Cmp.prevItem.key] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
      }),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline({
        [PluginsKeyMapping.Cmp.nextItem.key] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
        },
        [PluginsKeyMapping.Cmp.prevItem.key] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
      }),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    require('luasnip.loaders.from_vscode').load({
      paths = { '~/.config/nvim/snippets' },
    })

    local ls = require('luasnip')

    vim.keymap.set({ 'i', 's' }, PluginsKeyMapping.Cmp.snipParamsNext.key, function()
      ls.jump(1)
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, PluginsKeyMapping.Cmp.snipParamsPrev.key, function()
      ls.jump(-1)
    end, { silent = true })
  end,
}
