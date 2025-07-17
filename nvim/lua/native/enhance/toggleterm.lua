-- https://github.com/akinsho/toggleterm.nvim
return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  config = function()
    local toggleterm = require('toggleterm')
    local terms = require('toggleterm.terminal').Terminal
    local file_utils = require('native.utils.file')

    toggleterm.setup({
      float_opts = {
        border = 'curved',
        zindex = 1,
      },
    })

    local lazygit = terms:new({
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'tab',
      hidden = false,
    })

    local cmd
    local code_runner = terms:new({
      cmd = function()
        if cmd == nil then
          vim.notify('no executable programs')
          return ''
        end

        return cmd
      end,
      direction = 'float',
      hidden = false,
      close_on_exit = false,
    })

    local toggle_lazygit = function()
      lazygit:toggle()
    end

    local run_code = function()
      local filetype = file_utils.current_type()
      local filepath = file_utils.current_path()
      local filename = file_utils.current_name()
      local dirpath = file_utils.curent_dir()

      cmd = ({
        javascript = 'node ' .. filepath,
        typescript = 'ts-node ' .. filepath,
        lua = 'lua ' .. filepath,
        rust = 'cd ' .. dirpath .. '&& rustc ' .. filename .. '&& ' .. dirpath .. '/' .. string.sub(filename, 0, -4),
      })[filetype]
      code_runner:toggle()
    end

    local keys = require('native.basic.keymaps').toggleterm
    vim.g.keyset('n', keys.run_code, run_code, { desc = 'run code' })
    vim.g.keyset('n', keys.toggle_lazy_git, toggle_lazygit, { desc = 'open lazygit' })
  end,
}
