vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom_grugfar', { clear = true }),
  pattern = 'grug-far',
  callback = function(event)
    vim.bo[event.buf].buflisted = false

    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        Utils.GrugFar.close()
      end, {
        buffer = event.buf,
        silent = true,
        desc = PluginsKeyMapping.GrugFar.close.desc,
      })

      vim.keymap.set('n', PluginsKeyMapping.Window.decrease.key, function()
        local width = math.max(40, Utils.GrugFar.get_width() - 10)
        Utils.GrugFar.set_width(width)
      end, {
        buffer = event.buf,
        silent = true,
        desc = PluginsKeyMapping.Window.decrease.desc,
      })

      vim.keymap.set('n', PluginsKeyMapping.Window.increase.key, function()
        local width = math.min(120, Utils.GrugFar.get_width() + 10)
        Utils.GrugFar.set_width(width)
      end, {
        buffer = event.buf,
        silent = true,
        desc = PluginsKeyMapping.Window.increase.desc,
      })
    end)
  end,
})

-- search/replace in multiple files
return {
  'MagicDuck/grug-far.nvim',
  opts = {
    headerMaxWidth = 80,
    engines = {
      ripgrep = {
        placeholders = {
          enabled = true,
          search = 'e.g. foo   foo([a-z0-9]*)   fun\\(',
          replacement = 'e.g. bar   ${1}_foo   $$MY_ENV_VAR ',
          filesFilter = 'e.g. *.lua   *.{css,js}   **/docs/*.md   (specify one per line)',
          flags = 'e.g. -i(ignore-case)  -w(word-regexp)  -U(multiline)',
          paths = '',
        },
      },
    },
    keymaps = {
      openLocation = { n = '<c-p>' },
      openNextLocation = { n = '<c-d>' },
      openPrevLocation = { n = '<c-u>' },
    },
  },
  cmd = { 'GrugFar', 'GrugFarWithin' },
  keys = {
    {
      PluginsKeyMapping.GrugFar.search.key,
      function()
        Utils.GrugFar.open()
      end,
      mode = { 'n', 'x' },
      desc = PluginsKeyMapping.GrugFar.search.desc,
    },
    {
      PluginsKeyMapping.GrugFar.searchCurrent.key,
      function()
        Utils.GrugFar.open(vim.fn.expand('%'))
      end,
      mode = { 'n', 'x' },
      desc = PluginsKeyMapping.GrugFar.searchCurrent.desc,
    },
    {
      PluginsKeyMapping.GrugFar.close.key,
      function()
        Utils.GrugFar.close()
      end,
      mode = { 'n', 'x' },
      desc = PluginsKeyMapping.GrugFar.close.desc,
    },
    {
      PluginsKeyMapping.GrugFar.resume.key,
      function()
        Utils.GrugFar.resume()
      end,
      mode = { 'n', 'x' },
      desc = PluginsKeyMapping.GrugFar.resume.desc,
    },
  },
}
