-- https://github.com/nvim-neo-tree/neo-tree.nvim
local neo_tree = require('neo-tree')
local width_data = os.getenv('HOME') .. '/dotfiles/nvim/lua/ui/.neo_tree_width'

function get_path(state)
  local node = state.tree:get_node()
  if node.type == 'message' then
    return
  end
  return node:get_id()
end

function get_width()
  local file = io.open(width_data, 'r')
  if file then
    local content = file:read('*a')
    file:close()
    return tonumber(content)
  else
    return 50
  end
end

local current_width = get_width()

function set_width(width)
  local _width = math.max(20, math.min(width, 130))
  local delta = _width - current_width
  local change = (delta >= 0 and '+' or '') .. tostring(delta)
  local file = io.open(width_data, 'w')
  if file then
    file:write(_width)
    file:close()
  end

  vim.cmd(':vertical resize' .. change .. '<CR>')
  current_width = _width
end

local open_status = false

neo_tree.setup({
  close_if_last_window = true,
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      never_show = { '.DS_Store', 'thumbs.db' },
    },
    follow_current_file = {
      enabled = false,
      leave_dirs_open = false,
    },
    use_libuv_file_watcher = true,
  },
  window = {
    position = 'left',
    width = current_width,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      -- remove default keys
      ['<space>'] = '',
      ['P'] = '',
      ['l'] = '',
      ['S'] = '',
      ['s'] = '',
      ['t'] = '',
      ['w'] = '',
      ['C'] = '',
      ['z'] = '',
      ['A'] = '',
      ['m'] = '',
      ['#'] = '',
      ['/'] = '',
      ['.'] = '',
      ['D'] = '',
      ['H'] = '',
      ['oc'] = '',
      ['od'] = '',
      ['om'] = '',
      ['on'] = '',
      ['os'] = '',
      ['ot'] = '',
      ['<bs>'] = '',
      -- keys
      ['q'] = function()
        -- do nothing
      end,
      ['<2-LeftMouse>'] = 'open',
      ['<cr>'] = 'open',
      ['<esc>'] = 'cancel',
      ['h'] = 'open_split',
      ['v'] = 'open_vsplit',
      ['a'] = 'add',
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['c'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
      ['<'] = 'prev_source',
      ['>'] = 'next_source',
      ['i'] = 'show_file_details',
      ['<C-f>'] = function(state)
        local path = get_path(state)
        if path then
          _G.resume_telescope({
            path = path,
          })
        end
      end,
      ['<C-p>'] = function(state)
        local path = get_path(state)
        if path then
          _G.resume_telescope({
            action = 'find_files',
            path = path,
          })
        end
      end,
      ['y'] = function(state)
        local path = get_path(state)
        if path then
          vim.fn.setreg('+', path)
          vim.fn.setreg('"', path)
          vim.notify(string.format('Copied %s to system clipboard!', path))
        end
      end,
      ['o'] = function(state)
        local path = get_path(state)
        if path then
          os.execute('open ' .. path)
        end
      end,
      ['<c-,>'] = function()
        set_width(current_width - 5)
      end,
      ['<c-.>'] = function()
        set_width(current_width + 5)
      end,
    },
  },
  event_handlers = {
    {
      event = 'neo_tree_window_before_close',
      handler = function()
        open_status = false
      end,
    },
    {
      event = 'neo_tree_window_before_open',
      handler = function()
        open_status = true
      end,
    },
  },
})

local utils = require('utils')

function _G.toggle_neo_tree()
  if open_status then
    vim.cmd('Neotree close')
  else
    if utils.current_file.is_exist() then
      vim.cmd('Neotree reveal')
    else
      vim.cmd('Neotree')
    end
  end
end

local manager = require('neo-tree.sources.manager')
local command = require('neo-tree.command')
local auto_open_status = false
local config_group = vim.api.nvim_create_augroup('neotree_actions', { clear = true })

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = config_group,
  callback = function()
    if vim.g.auto_open_explorer and not auto_open_status then
      auto_open_status = true
      if not utils.session_exist() then
        manager.show('filesystem')
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = config_group,
  callback = function()
    if
      not open_status
      or vim.g.is_diffview_opening
      or vim.g.is_telescope_pickers_opening
      or not vim.g.follow_current_file
      or not utils.current_file.is_exist()
      or not utils.current_file.is_in_cwd()
    then
      vim.g.is_telescope_pickers_opening = false
      return
    end

    command.execute({ source_name = 'filesystem', action = 'show', reveal = true, reveal_force_cwd = true })
  end,
})
