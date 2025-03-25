-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    local neo_tree = require('neo-tree')
    local neo_tree_utils = require('neo-tree.utils')
    local global_config_utils = require('utils.global_config')
    local file_utils = require('utils.file')
    local common_utils = require('utils.common')
    local telescope_utils = require('utils.telescope')
    local keys = require('basic.keymaps').neo_tree

    local get_path = function(state)
      local node = state.tree:get_node()
      if node.type == 'message' then
        return
      end
      return node:get_id()
    end

    local current_width = vim.g.neo_tree_width or 50

    local set_width = function(width)
      local _width = math.max(20, math.min(width, 130))
      local delta = _width - current_width
      local change = (delta >= 0 and '+' or '') .. tostring(delta)
      global_config_utils.set_global_config('neo_tree_width', _width)
      vim.cmd(':vertical resize' .. change .. '<CR>')
      current_width = _width
    end

    local current_source = vim.g.neo_tree_source or 'filesystem'

    local set_source = function()
      local all_sources = { 'filesystem', 'git_status', 'buffers' }
      local filename = file_utils.current_name()
      for _, source in ipairs(all_sources) do
        if string.find(filename, source) ~= nil then
          current_source = source
          break
        end
      end
      global_config_utils.set_global_config('neo_tree_source', current_source)
    end

    neo_tree.setup({
      source_selector = {
        winbar = true,
        statusline = false,
        highlight_tab = 'Comment',
        highlight_separator = 'Comment',
        highlight_background = 'Comment',
      },
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      enable_diagnostics = false,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = false,
          never_show = { '.DS_Store', 'thumbs.db', '.git', '.eden-mono', '.temp', 'node_modules' },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
      },
      buffers = {
        show_unloaded = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
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
          -- 移除默认映射
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
              telescope_utils.telescope_resume({
                path = path,
              })
            end
          end,
          ['<C-p>'] = function(state)
            local path = get_path(state)
            if path then
              telescope_utils.telescope_resume({
                action = 'find_files',
                path = path,
              })
            end
          end,
          ['y'] = function(state)
            local path = get_path(state)
            if path then
              local _, filename = neo_tree_utils.split_path(path)
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
            global_config_utils.set_global_config('neo_tree_open_status', false)
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

    vim.g.keyset('n', keys.toggle, function()
      vim.cmd('Neotree toggle ' .. current_source .. (file_utils.is_current_exist() and ' reveal' or ''))
    end, { desc = 'toggle neotree' })
  end,
}
