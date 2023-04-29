-- https://github.com/akinsho/toggleterm.nvim
local status_ok, toggleterm = pcall(require, 'toggleterm')

if not status_ok then
  vim.notify('toggleterm not found!')
  return
end

toggleterm.setup({
  float_opts = {
    border = 'curved',
    zindex = 1,
  },
})

local terms = require('toggleterm.terminal').Terminal

local lazygit = terms:new({
  cmd = 'lazygit',
  dir = 'git_dir',
  direction = 'float',
  hidden = false,
})

function _G.lazygit_toggle()
  lazygit:toggle()
end

local filetype, filepath, cmd
local code_runner = terms:new({
  cmd = function()
    if cmd == nil then
      vim.notify('no executable programs')
      return ''
    end

    return cmd .. ' ' .. filepath
  end,
  direction = 'float',
  hidden = true,
  close_on_exit = false,
})

function _G.code_runner_toggle()
  filetype = vim.o.filetype
  filepath = vim.api.nvim_buf_get_name(0)
  cmd = ({
    javascript = 'node',
    typescript = 'ts-node',
    lua = 'lua',
    rust = 'rustc',
  })[filetype]
  code_runner:toggle()
end
