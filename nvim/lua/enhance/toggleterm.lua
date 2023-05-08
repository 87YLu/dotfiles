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
  direction = 'tab',
  hidden = false,
})

function _G.lazygit_toggle()
  lazygit:toggle()
end

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
  hidden = true,
  close_on_exit = false,
})

function _G.code_runner_toggle()
  local filetype = vim.o.filetype
  local filepath = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.fnamemodify(filepath, ':t')
  local dirpath = vim.fn.fnamemodify(filepath, ':h')

  cmd = ({
    javascript = 'node ' .. filepath,
    typescript = 'ts-node ' .. filepath,
    lua = 'lua ' .. filepath,
    rust = 'cd ' .. dirpath .. '&& rustc ' .. filename .. '&& ' .. dirpath .. '/' .. string.sub(filename, 0, -4),
  })[filetype]
  code_runner:toggle()
end
