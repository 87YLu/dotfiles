---@class UtilsColorTheme
local M = {}

local dotfiles = vim.env.HOME .. '/dotfiles'

---@param is_dark boolean
local function sync_tmux(is_dark)
  if not vim.g.tmux then
    return
  end
  local theme_file = dotfiles .. '/tmux/' .. (is_dark and 'theme-dark.conf' or 'theme-light.conf')
  vim.fn.jobstart({ 'tmux', 'source-file', theme_file }, { detach = true })
end

---@param is_dark boolean
local function sync_lazygit(is_dark)
  local base_config = dotfiles .. '/lazygit/config.yml'
  local theme_file = dotfiles .. '/lazygit/' .. (is_dark and 'theme-dark.yml' or 'theme-light.yml')
  vim.env.LG_CONFIG_FILE = base_config .. ',' .. theme_file
end

---@param is_dark boolean
local function sync_kitty(is_dark)
  if not vim.g.kitty then
    return
  end

  local theme_file = dotfiles .. '/terminals/kitty/' .. (is_dark and 'theme-dark.conf' or 'theme-light.conf')
  local kitty = '/Applications/kitty.app/Contents/MacOS/kitty'

  vim.fn.jobstart({
    'bash',
    '-c',
    string.format(
      'for sock in /tmp/mykitty-*; do [ -S "$sock" ] && %s @ --to unix:"$sock" set-colors -a -c %s; done',
      kitty,
      theme_file
    ),
  }, { detach = true })
end

---@param is_dark boolean
M.sync = function(is_dark)
  sync_tmux(is_dark)
  sync_lazygit(is_dark)
  sync_kitty(is_dark)
end

return M
