-- https://github.com/nvim-telescope/telescope.nvim
return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function()
    local function is_editing_win(winnr)
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
      return buftype == ''
    end

    local function get_editing_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if is_editing_win(win) then
          return win
        end
      end
      return 0
    end

    local telescope = require('telescope')
    local telescope_builtin = require('telescope.builtin')
    local file_utils = require('utils.file')

    telescope.setup({
      defaults = {
        initial_mode = 'insert',
        mappings = {
          i = {
            ['<Down>'] = 'move_selection_next',
            ['<Up>'] = 'move_selection_previous',
            ['<C-c>'] = 'close',
            ['<C-u>'] = 'preview_scrolling_up',
            ['<C-d>'] = 'preview_scrolling_down',
            ['<C-r>'] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-u>', true, false, true), 'n', true)
            end,
          },
        },
        cache_picker = {
          num_pickers = 50,
        },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
          },
          height = 0.80,
          width = 0.75,
        },
        -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/958
        -- https://github.com/nvim-telescope/telescope.nvim/pull/531
        get_selection_window = function()
          if not is_editing_win(vim.api.nvim_get_current_win()) then
            return get_editing_win()
          end
          return 0
        end,
      },
    })

    telescope.load_extension('ui-select')

    local telescope_utils = require('utils.telescope')

    local find_files = function()
      telescope_utils.telescope_resume({
        action = 'find_files',
      })
    end

    local global_search = telescope_utils.telescope_resume

    local search_in_current_file = function()
      telescope_utils.telescope_resume({
        path = file_utils.current_path(),
      })
    end

    local list_pickers = telescope_builtin.pickers

    local list_recently_files = function()
      telescope_builtin.oldfiles({ cwd_only = true })
    end

    -- https://github.com/nvim-telescope/telescope.nvim/issues/2027
    -- https://github.com/Exafunction/codeium.vim/issues/80
    vim.api.nvim_create_autocmd('WinLeave', {
      callback = function()
        if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'i', false)
        end
      end,
    })

    require('basic.keymaps').telescope(
      find_files,
      global_search,
      search_in_current_file,
      list_pickers,
      list_recently_files
    )
  end,
}
