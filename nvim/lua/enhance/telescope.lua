-- https://github.com/nvim-telescope/telescope.nvim
local status_ok, telescope = pcall(require, 'telescope')

if not status_ok then
  vim.notify('telescope not found!')
  return
end

telescope.setup({
  defaults = {
    initial_mode = 'insert',
    mappings = require('basic.keymaps').telescope_keys,
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
  },
})

telescope.load_extension('ui-select')

local telescope_state = require('telescope.state')
local telescope_builtin = require('telescope.builtin')

function get_cache_index(path, prefix)
  local cache_index = 0
  local cached_pickers = telescope_state.get_global_key('cached_pickers') or {}

  for i, picker in ipairs(cached_pickers) do
    if picker.prompt_title == path and picker.prompt_prefix == prefix then
      cache_index = i
      break
    end
  end

  return cache_index
end

function _G.resume_live_grep(path)
  if path == nil then
    path = vim.loop.cwd()
  end

  local prompt_prefix = 'live_grep 󰺯 '
  local cache_index = get_cache_index(path, prompt_prefix)

  if cache_index == 0 then
    telescope_builtin.live_grep({
      search_dirs = { path },
      prompt_title = path,
      prompt_prefix = prompt_prefix,
    })
  else
    telescope_builtin.resume({ cache_index = cache_index })
  end
end

function _G.resume_find_files(path)
  if path == nil then
    path = vim.loop.cwd()
  end

  local prompt_prefix = 'find_files 󰱽 '
  local cache_index = get_cache_index(path, prompt_prefix)

  if cache_index == 0 then
    telescope_builtin.find_files({
      search_dirs = { path },
      prompt_title = path,
      prompt_prefix = prompt_prefix,
    })
  else
    telescope_builtin.resume({ cache_index = cache_index })
  end
end
