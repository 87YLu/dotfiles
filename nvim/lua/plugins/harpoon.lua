local normalize_list = function(t)
  local normalized = {}
  for _, v in pairs(t) do
    if v ~= nil then
      table.insert(normalized, v)
    end
  end
  return normalized
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'LazyFile',
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  config = function()
    local harpoon = require('harpoon')

    harpoon:setup()

    vim.keymap.set('n', PluginsKeyMapping.Harpoon.add.key, function()
      harpoon:list():add()
      vim.notify(PluginsKeyMapping.Harpoon.add.desc)
    end, {
      desc = PluginsKeyMapping.Harpoon.add.desc,
    })

    vim.keymap.set('n', PluginsKeyMapping.Harpoon.clear.key, function()
      harpoon:list():clear()
      vim.notify(PluginsKeyMapping.Harpoon.clear.desc)
    end, {
      desc = PluginsKeyMapping.Harpoon.clear.desc,
    })

    vim.keymap.set('n', PluginsKeyMapping.Harpoon.list.key, function()
      Snacks.picker({
        finder = function()
          local file_paths = {}
          local list = normalize_list(harpoon:list().items)
          for i, item in ipairs(list) do
            table.insert(file_paths, { text = item.value, file = item.value })
          end
          return file_paths
        end,
        win = {
          input = {
            keys = { ['dd'] = { 'harpoon_delete', mode = { 'n', 'x' } } },
          },
          list = {
            keys = { ['dd'] = { 'harpoon_delete', mode = { 'n', 'x' } } },
          },
        },
        actions = {
          harpoon_delete = function(picker, item)
            local to_remove = item or picker:selected()
            harpoon:list():remove({ value = to_remove.text })
            harpoon:list().items = normalize_list(harpoon:list().items)
            picker:find({ refresh = true })
          end,
        },
      })
    end, {
      desc = PluginsKeyMapping.Harpoon.list.desc,
    })
  end,
}

