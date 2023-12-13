-- https://github.com/nvim-neo-tree/neo-tree.nvim
local neo_tree = require('neo-tree')
local neo_tree_utils = require('neo-tree.utils')
local global_config_utils = require('utils.global_config')
local current_file = require('utils.current_file')
local common_utils = require('utils.common')

function get_path(state)
  local node = state.tree:get_node()
  if node.type == 'message' then
    return
  end
  return node:get_id()
end

local current_width = vim.g.neo_tree_width or 50

function set_width(width)
  local _width = math.max(20, math.min(width, 130))
  local delta = _width - current_width
  local change = (delta >= 0 and '+' or '') .. tostring(delta)
  global_config_utils.set_global_config('neo_tree_width', _width)
  vim.cmd(':vertical resize' .. change .. '<CR>')
  current_width = _width
end

local current_source = vim.g.neo_tree_source or 'filesystem'

function set_source()
  local all_sources = { 'filesystem', 'git_status', 'buffers' }
  local filename = current_file.name()
  for _, source in ipairs(all_sources) do
    if string.find(filename, source) ~= nil then
      current_source = source
      break
    end
  end
  global_config_utils.set_global_config('neo_tree_source', current_source)
end

local position = vim.g.neotree_position

neo_tree.setup({
  source_selector = {
    winbar = true,
    statusline = false,
    highlight_tab = 'Comment',
    highlight_separator = 'Comment',
    highlight_background = 'Comment',
  },
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
  buffers = {
    show_unloaded = true,
    follow_current_file = {
      enabled = false,
      leave_dirs_open = false,
    },
  },
  window = {
    position = position,
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
      ['<leader>'] = 'open',
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
          local _path, filename = neo_tree_utils.split_path(path)
          common_utils.copy(filename)
        end
      end,
      ['Y'] = function(state)
        local path = get_path(state)
        if path then
          common_utils.copy(path)
        end
      end,
      ['o'] = function(state)
        local path = get_path(state)
        if path then
          os.execute('open ' .. path)
        end
      end,
      ['<A-,>'] = function()
        set_width(current_width - 5)
      end,
      ['<A-.>'] = function()
        set_width(current_width + 5)
      end,
    },
  },
  event_handlers = {
    {
      event = 'neo_tree_buffer_enter',
      handler = set_source,
    },
    {
      event = 'neo_tree_window_before_close',
      handler = function()
        if not vim.g.before_quit then
          global_config_utils.set_global_config('neo_tree_open_status', false)
        end
      end,
    },
    {
      event = 'neo_tree_window_before_open',
      handler = function()
        global_config_utils.set_global_config('neo_tree_open_status', true)
      end,
    },
  },
})

local command = require('neo-tree.command')
local config_group = vim.api.nvim_create_augroup('neotree_actions', { clear = true })

function _G.toggle_neo_tree()
  if current_file.type() ~= 'neo-tree' then
    command.execute({
      source = current_source,
      action = 'focus',
      reveal = true,
      reveal_force_cwd = true,
    })
    return
  end
  vim.cmd('Neotree toggle ' .. current_source .. (current_file.is_exist() and ' reveal' or ''))
end

local flag = false

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = config_group,
  once = true,
  callback = function()
    if
      ((vim.g.neo_tree_open_status == nil) and true or vim.g.neo_tree_open_status)
      and position ~= 'float'
      and not flag
    then
      flag = true
      common_utils.set_timeout(function()
        command.execute({
          source = current_source,
          action = 'show',
          reveal = true,
          reveal_force_cwd = true,
        })
      end, 0)
    end
  end,
})
