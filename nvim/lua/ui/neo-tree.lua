-- https://github.com/nvim-neo-tree/neo-tree.nvim
local neo_tree = require('neo-tree')

function Get_path(state)
  local node = state.tree:get_node()
  if node.type == 'message' then
    return
  end
  return node:get_id()
end

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
      enabled = true,
      leave_dirs_open = false,
    },
    use_libuv_file_watcher = true,
  },
  window = {
    position = 'left',
    width = 40,
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
      ['q'] = '',
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
        local path = Get_path(state)
        if path then
          _G.resume_live_grep(path)
        end
      end,
      ['<C-p>'] = function(state)
        local path = Get_path(state)
        if path then
          _G.resume_find_files(path)
        end
      end,
      ['y'] = function(state)
        local path = Get_path(state)
        if path then
          vim.fn.setreg('+', path)
          vim.fn.setreg('"', path)
          vim.notify(string.format('Copied %s to system clipboard!', path))
        end
      end,
      ['o'] = function(state)
        local path = Get_path(state)
        if path then
          os.execute('open ' .. path)
        end
      end,
    },
  },
})

local auto_open_status = false
local config_group = vim.api.nvim_create_augroup('neotree_autoopen', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = config_group,
  callback = function()
    if vim.g.auto_open_explorer and not auto_open_status then
      require('neo-tree.sources.manager').show('filesystem')
      auto_open_status = true
    end
  end,
})
