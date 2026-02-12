local nvim_tree_width_key = 'nvim_tree_width'

local get_nvim_tree_width = function()
  return Utils.NvimConfig.get(nvim_tree_width_key, 40)
end

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-h>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<leader>', api.node.open.edit, opts('Open'))

  vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
  vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', 'o', api.node.run.system, opts('System Open'))

  vim.keymap.set('n', PluginsKeyMapping.Window.decrease.key, function()
    local width = math.max(10, get_nvim_tree_width() - 10)
    vim.cmd('NvimTreeResize ' .. width)
    Utils.NvimConfig.set(nvim_tree_width_key, width)
  end, opts(PluginsKeyMapping.Window.decrease.desc))
  vim.keymap.set('n', PluginsKeyMapping.Window.increase.key, function()
    local width = math.min(80, get_nvim_tree_width() + 10)
    vim.cmd('NvimTreeResize ' .. width)
    Utils.NvimConfig.set(nvim_tree_width_key, width)
  end, opts(PluginsKeyMapping.Window.increase.desc))

  vim.keymap.set('n', PluginsKeyMapping.NvimTree.grugFar.key, function()
    local absolute_path = api.tree.get_node_under_cursor().absolute_path
    Utils.GrugFar.open(absolute_path)
  end, opts(PluginsKeyMapping.NvimTree.grugFar.desc))
end

return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup({
      on_attach = my_on_attach,
      view = {
        width = get_nvim_tree_width(),
      },
      diagnostics = {
        enable = true,
      },
      update_focused_file = {
        enable = true,
      },
    })

    local api = require('nvim-tree.api')

    vim.keymap.set('n', PluginsKeyMapping.NvimTree.toggle.key, function()
      api.tree.toggle({ path = Utils.Path.get_project_root(), find_file = true, update_root = false, focus = true })
      Utils.NvimConfig.set('nvim_tree_visible', api.tree.is_visible())
    end, {
      desc = PluginsKeyMapping.NvimTree.toggle.desc,
    })
  end,
}
