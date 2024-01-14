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

    local show_marks = function()
      if has_telescope then
        telescope.extensions.harpoon.marks()
      else
        vim.notify('need telescope')
      end
    end

    local add_mark = function()
      mark.add_file()
      vim.notify('add mark')
    end

    local remove_mark = function()
      mark.rm_file()
      vim.notify('remove mark')
    end

    local clear_marks = function()
      mark.clear_all()
      vim.notify('clear all marks')
    end

    require('basic.keymaps').harpoon(show_marks, add_mark, remove_mark, clear_marks)
  end,
}
