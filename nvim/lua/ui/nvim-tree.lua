-- https://github.com/nvim-tree/nvim-tree.lua
local status_ok, nvim_tree = pcall(require, 'nvim-tree')

if not status_ok then
  vim.notify('nvim-tree not found!')
  return
end

nvim_tree.setup({
  -- 不显示 git 状态图标
  git = {
    enable = false,
  },
  -- project plugin 需要这样设置
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    require('basic.keymaps').nvimtree_keys(api, bufnr)
  end,
  view = {
    -- 宽度
    width = 40,
    -- 也可以 'right'
    side = 'left',
    -- 隐藏根目录
    hide_root_folder = false,
    mappings = {
      custom_only = false,
    },
    -- 不显示行数
    number = false,
    relativenumber = false,
    -- 显示图标
    signcolumn = 'yes',
  },
  actions = {
    open_file = {
      -- 首次打开大小适配
      resize_window = true,
      -- 打开文件时关闭
      quit_on_open = false,
    },
  },
  system_open = {
    cmd = 'open',
  },
})

-- 自动关闭
vim.cmd([[
  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
