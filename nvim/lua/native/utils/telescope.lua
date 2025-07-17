local has_telescope = pcall(require, 'telescope')

if not has_telescope then
  return {
    telescope_resume = function() end,
    telescope_select = function() end,
  }
end

local state = require('telescope.state')
local builtin = require('telescope.builtin')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local common_utils = require('native.utils.common')
local file_utils = require('native.utils.file')

local live_grep_prefix = 'live_grep 󰺯 '
local find_files_prefix = 'find_files 󰱽 '

local M = {}

function M.telescope_resume(params)
  params = params or {}
  local path = params.path ~= nil and params.path or common_utils.cwd()
  local action = params.action ~= nil and params.action or 'live_grep'

  local prompt_prefix = action == 'live_grep' and live_grep_prefix or find_files_prefix
  local relative_path = file_utils.relative_path(path)
  local cache_index = 0
  local cached_pickers = state.get_global_key('cached_pickers') or {}

  for i, picker in ipairs(cached_pickers) do
    if picker.prompt_title == relative_path and picker.prompt_prefix == prompt_prefix then
      cache_index = i
      break
    end
  end

  if cache_index ~= 0 then
    builtin.resume({ cache_index = cache_index })
    return
  end

  local action_params = {
    search_dirs = { path },
    prompt_title = relative_path,
    prompt_prefix = prompt_prefix,
  }

  if action == 'live_grep' then
    builtin.live_grep(action_params)
  else
    builtin.find_files(action_params)
  end
end

function M.telescope_select(config)
  local title = config.title
  local items = config.items
  local prefix = config.prefix
  local handleMove = config.handleMove
  local handleSelect = config.handleSelect
  local handleClose = config.handleClose

  local picker = pickers.new({
    results_title = title,
    finder = finders.new_table({
      results = items,
    }),
    sorter = sorters.get_fzy_sorter(),
    prompt_title = '',
    prompt_prefix = prefix,
    layout_config = {
      height = 0.3,
      width = 0.3,
    },
    attach_mappings = function(prompt_bufnr, map)
      local down = function()
        actions.move_selection_next(prompt_bufnr)
        if handleMove then
          handleMove(action_state.get_selected_entry().value)
        end
      end

      local up = function()
        actions.move_selection_previous(prompt_bufnr)
        if handleMove then
          handleMove(action_state.get_selected_entry().value)
        end
      end

      local close = function()
        actions.close(prompt_bufnr)
        if handleClose then
          handleClose()
        end
      end

      local select = function()
        local value = action_state.get_selected_entry().value
        actions.close(prompt_bufnr)
        if handleSelect then
          handleSelect(value)
        end
      end

      map({ 'i', 'n' }, '<CR>', select)
      map({ 'i', 'n' }, '<Down>', down)
      map({ 'i', 'n' }, '<Tab>', down)
      map({ 'i', 'n' }, '<C-j>', down)
      map('i', '<C-n>', down)
      map({ 'i', 'n' }, '<Up>', up)
      map({ 'i', 'n' }, '<C-k>', up)
      map('i', '<C-p>', up)
      map('n', '<Esc>', close)
      map('i', '<C-c>', close)

      return true
    end,
  })

  picker:find()
end

local clear_cached_pickers = function()
  local cached_pickers = state.get_global_key('cached_pickers') or {}
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

return M
