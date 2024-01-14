-- https://github.com/ThePrimeagen/harpoon
-- 添加代码书签
return {
  'ThePrimeagen/harpoon',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harpoon').setup()

    local has_telescope, telescope = pcall(require, 'telescope')

    if has_telescope then
      pcall(telescope.load_extension, 'harpoon')
    end

    local mark = require('harpoon.mark')
    local keys = require('basic.keymaps').harpoon

    vim.g.keyset('n', keys.show_marks, function()
      if has_telescope then
        telescope.extensions.harpoon.marks()
      else
        vim.notify('need telescope')
      end
    end, { desc = 'show marks' })
    vim.g.keyset('n', keys.add_mark, function()
      mark.add_file()
      vim.notify('add mark')
    end, { desc = 'add mark' })
    vim.g.keyset('n', keys.remove_mark, function()
      mark.rm_file()
      vim.notify('remove mark')
    end, { desc = 'remove mark' })
    vim.g.keyset('n', keys.clear_marks, function()
      mark.clear_all()
      vim.notify('clear all marks')
    end, { desc = 'clear all marks' })
  end,
}
