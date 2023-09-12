-- https://github.com/nvim-neo-tree/neo-tree.nvim
local neo_tree = require('neo-tree')
local width_data = os.getenv('HOME') .. '/dotfiles/nvim/lua/ui/.neo_tree_width'
local source_data = os.getenv('HOME') .. '/dotfiles/nvim/lua/ui/.neo_tree_source'
local utils = require('utils')

function get_path(state)
  local node = state.tree:get_node()
  if node.type == 'message' then
    return
  end
  return node:get_id()
end

local current_width = utils.file.get_content(width_data, 50)

function set_width(width)
  local _width = math.max(20, math.min(width, 130))
  local delta = _width - current_width
  local change = (delta >= 0 and '+' or '') .. tostring(delta)
  utils.file.write_content(width_data, _width)
  vim.cmd(':vertical resize' .. change .. '<CR>')
  current_width = _width
end

local current_source = utils.file.get_content(source_data, 'filesystem')

function set_source()
  local all_sources = { 'filesystem', 'git_status', 'buffers' }
  local filename = utils.current_file.name()
  for _, source in ipairs(all_sources) do
    if string.find(filename, source) ~= nil then
      current_source = source
      break
    end
  end
  utils.file.write_content(source_data, current_source)
end

local open_status = false

neo_tree.setup({
  source_selector = {
    winbar = true,
    statusline = false,
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
    {
      event = 'neo_tree_buffer_enter',
      handler = set_source,
    },
  },
})

function _G.toggle_neo_tree()
  if open_status then
    vim.cmd('Neotree close')
  else
    vim.cmd('Neotree ' .. current_source .. (utils.current_file.is_exist() and ' reveal' or ''))
  end
end

local command = require('neo-tree.command')
local auto_open_status = false
local config_group = vim.api.nvim_create_augroup('neotree_actions', { clear = true })

function _G.focus_current_file()
  command.execute({
    source = current_source,
    action = 'focus',
    reveal = true,
    reveal_force_cwd = true,
  })
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = config_group,
  callback = function()
    if vim.g.auto_open_explorer and not auto_open_status then
      auto_open_status = true
      utils.set_timeout(function()
        if current_source ~= 'filesystem' then
          vim.cmd('Neotree show filesystem')
        end
        vim.cmd('Neotree show ' .. current_source)
      end, 0)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = config_group,
  callback = function()
    vim.g.is_telescope_pickers_opening = false
  end,
})
