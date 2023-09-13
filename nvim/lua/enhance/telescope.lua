-- https://github.com/nvim-telescope/telescope.nvim
local status_ok, telescope = pcall(require, 'telescope')

if not status_ok then
  vim.notify('telescope not found!')
  return
end

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
  extensions = {
    coc = {
      prefer_locations = true,
    },
  },
})

telescope.load_extension('ui-select')
telescope.load_extension('coc')

local telescope_state = require('telescope.state')
local telescope_builtin = require('telescope.builtin')
local utils = require('utils')
local live_grep_prefix = 'live_grep 󰺯 '
local find_files_prefix = 'find_files 󰱽 '

function _G.resume_telescope(params)
  params = params or {}
  local path = params.path ~= nil and params.path or utils.cwd()
  local action = params.action ~= nil and params.action or 'live_grep'

  local prompt_prefix = action == 'live_grep' and live_grep_prefix or find_files_prefix
  local relative_path = utils.file.relative_path(path)
  local cache_index = 0
  local cached_pickers = telescope_state.get_global_key('cached_pickers') or {}

  for i, picker in ipairs(cached_pickers) do
    if picker.prompt_title == relative_path and picker.prompt_prefix == prompt_prefix then
      cache_index = i
      break
    end
  end

  if cache_index ~= 0 then
    telescope_builtin.resume({ cache_index = cache_index })
    return
  end

  local action_params = {
    search_dirs = { path },
    prompt_title = relative_path,
    prompt_prefix = prompt_prefix,
  }

  if action == 'live_grep' then
    telescope_builtin.live_grep(action_params)
  else
    telescope_builtin.find_files(action_params)
  end
end

function clear_cached_pickers()
  local cached_pickers = telescope_state.get_global_key('cached_pickers') or {}
  for i, picker in ipairs(cached_pickers) do
    if picker.prompt_prefix ~= live_grep_prefix and picker.prompt_prefix ~= find_files_prefix then
      table.remove(cached_pickers, i)
    end
  end
end

vim.api.nvim_create_autocmd('BufLeave', {
  pattern = '',
  callback = function()
    if vim.o.filetype == 'TelescopePrompt' then
      clear_cached_pickers()
    end
  end,
})
