local M = {}

local stash_dir = vim.fn.stdpath('cache') .. '/explorer-undo-stash/'
local uv = vim.uv or vim.loop

local function ensure_stash_dir()
  vim.fn.mkdir(stash_dir, 'p')
end

-- ── Undo History ────────────────────────────────────────────────
local history_stack = {}

local function history_push(entry)
  entry.timestamp = os.time()
  history_stack[#history_stack + 1] = entry
end

local function history_pop()
  if #history_stack == 0 then
    return nil
  end
  return table.remove(history_stack)
end

-- ── Stash helpers ───────────────────────────────────────────────
local function stash_file(src)
  ensure_stash_dir()
  local id = ('%d_%d'):format(os.time(), math.random(10000, 99999))
  local dest = ('%s/%s_%s'):format(stash_dir, id, vim.fn.fnamemodify(src, ':t'))
  local flag = vim.fn.isdirectory(src) == 1 and '-a' or '-p'
  vim.fn.system({ 'cp', flag, src, dest })
  return vim.v.shell_error == 0 and dest or nil
end

local function restore_from_stash(stash_path, original_path)
  if not uv.fs_stat(stash_path) then
    return false
  end
  vim.fn.mkdir(vim.fs.dirname(original_path), 'p')
  if os.rename(stash_path, original_path) then
    return true
  end
  vim.fn.system({ 'mv', stash_path, original_path })
  return vim.v.shell_error == 0
end

-- ── Yank / utility helpers ──────────────────────────────────────
local function with_item_file(fn)
  return function(_, item)
    if item and item.file then
      fn(item.file)
    end
  end
end

-- ── Actions (lazy-loaded) ───────────────────────────────────────
local function add_actions()
  local ok, Actions = pcall(require, 'snacks.explorer.actions')
  if not ok then
    return
  end
  local Tree = require('snacks.explorer.tree')
  local a = Actions.actions

  local function refresh_and_update(picker, dirs, target)
    for _, d in ipairs(dirs) do
      Tree:refresh(d)
    end
    Actions.update(picker, target and { target = target } or nil)
  end

  -- Delete (undoable) ─────────────────────────────────────────
  a.explorer_del_undoable = function(picker)
    local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected({ fallback = true }))
    if #paths == 0 then
      return
    end

    Snacks.picker.util.confirm(
      'Delete ' .. (#paths == 1 and vim.fn.fnamemodify(paths[1], ':p:~:.') or (#paths .. ' files')) .. '?',
      function()
        local deleted, stashes = {}, {}
        for _, path in ipairs(paths) do
          local sp = stash_file(path)
          local ok_del, err = Actions.trash(path)
          if ok_del then
            Snacks.bufdelete({ file = path, force = true })
            deleted[#deleted + 1], stashes[#stashes + 1] = path, sp or ''
          else
            Snacks.notify.error('Failed to delete `' .. path .. '`:\n' .. (err or ''))
            if sp then
              vim.fn.delete(sp, 'rf')
            end
          end
          Tree:refresh(vim.fs.dirname(path))
        end
        if #deleted > 0 then
          history_push({ op = 'delete', paths = deleted, stash_paths = stashes })
        end
        picker.list:set_selected()
        Actions.update(picker)
      end
    )
  end

  -- Rename (undoable) ─────────────────────────────────────────
  a.explorer_rename_undoable = function(picker, item)
    if not item then
      return
    end
    local from, dir = item.file, vim.fs.dirname(item.file)
    local basename = vim.fn.fnamemodify(from, ':t')

    Snacks.input({ prompt = 'Rename', default = basename }, function(new_name)
      if not new_name or new_name == '' or new_name == basename then
        return
      end
      local to = dir .. '/' .. new_name
      Snacks.rename.rename_file({
        from = from,
        to = to,
        on_rename = function(np, fp)
          history_push({ op = 'rename', old_path = fp, new_path = np })
          refresh_and_update(picker, { vim.fs.dirname(fp), vim.fs.dirname(np) }, np)
        end,
      })
    end)
  end

  -- Add (undoable) ────────────────────────────────────────────
  a.explorer_add_undoable = function(picker, ...)
    local dir = picker:dir()
    local orig_input = Snacks.input
    Snacks.input = function(opts, cb)
      return orig_input(opts, function(value)
        if value and not value:find('^%s*$') then -- FIX: was '^%s$', only matched single whitespace
          local path = vim.fs.normalize(dir .. '/' .. value)
          vim.defer_fn(function()
            if uv.fs_stat(path) then
              history_push({ op = 'create', path = path })
            end
          end, 300)
        end
        cb(value)
      end)
    end
    a.explorer_add(picker, ...)
    vim.schedule(function()
      Snacks.input = orig_input
    end)
  end

  -- Move (undoable) ───────────────────────────────────────────
  a.explorer_move_undoable = function(picker)
    local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
    if #paths == 0 then
      return Snacks.notify.warn('No files selected to move.')
    end
    local target = picker:dir()

    Snacks.picker.util.confirm(
      'Move '
        .. (#paths == 1 and vim.fn.fnamemodify(paths[1], ':p:~:.') or (#paths .. ' files'))
        .. ' to '
        .. vim.fn.fnamemodify(target, ':p:~:.')
        .. '?',
      function()
        local items = {}
        for _, from in ipairs(paths) do
          local to = target .. '/' .. vim.fn.fnamemodify(from, ':t')
          Snacks.rename.rename_file({ from = from, to = to })
          Tree:refresh(vim.fs.dirname(from))
          items[#items + 1] = { from = from, to = to }
        end
        Tree:refresh(target)
        picker.list:set_selected()
        Actions.update(picker, { target = target })
        if #items > 0 then
          history_push({ op = 'move', items = items })
        end
      end
    )
  end

  -- Paste (undoable) ──────────────────────────────────────────
  a.explorer_paste_undoable = function(picker, ...)
    local dir = picker:dir()
    local before = {}
    for name in vim.fs.dir(dir) do
      before[name] = true
    end
    history_push({ op = 'paste', dir = dir, before = before, created_paths = nil })
    a.explorer_paste(picker, ...)
  end

  -- Undo ──────────────────────────────────────────────────────
  local undo_handlers = {
    delete = function(entry)
      local restored, failed = 0, {}
      for i, path in ipairs(entry.paths) do
        local sp = entry.stash_paths and entry.stash_paths[i]
        if sp and sp ~= '' and restore_from_stash(sp, path) then
          Tree:refresh(vim.fs.dirname(path))
          restored = restored + 1
        else
          failed[#failed + 1] = vim.fn.fnamemodify(path, ':t')
        end
      end
      return #failed == 0,
        #failed == 0 and ('Restored ' .. restored .. ' file(s)')
          or ('Restored ' .. restored .. ', failed: ' .. table.concat(failed, ', '))
    end,

    rename = function(entry)
      if not uv.fs_stat(entry.new_path) then
        return false, entry.new_path .. ' no longer exists'
      end
      vim.fn.mkdir(vim.fs.dirname(entry.old_path), 'p')
      Snacks.rename.rename_file({ from = entry.new_path, to = entry.old_path })
      Tree:refresh(vim.fs.dirname(entry.new_path))
      Tree:refresh(vim.fs.dirname(entry.old_path))
      return true, vim.fn.fnamemodify(entry.new_path, ':t') .. ' → ' .. vim.fn.fnamemodify(entry.old_path, ':t')
    end,

    create = function(entry)
      if not uv.fs_stat(entry.path) then
        return true, 'Already gone'
      end
      vim.fn.delete(entry.path, 'rf')
      pcall(Snacks.bufdelete, { file = entry.path, force = true })
      Tree:refresh(vim.fs.dirname(entry.path))
      return true, 'Removed: ' .. vim.fn.fnamemodify(entry.path, ':~:.')
    end,

    move = function(entry)
      local moved = 0
      for _, item in ipairs(entry.items) do
        if uv.fs_stat(item.to) then
          vim.fn.mkdir(vim.fs.dirname(item.from), 'p')
          os.rename(item.to, item.from)
          Tree:refresh(vim.fs.dirname(item.to))
          Tree:refresh(vim.fs.dirname(item.from))
          moved = moved + 1
        end
      end
      return moved > 0, 'Moved back ' .. moved .. '/' .. #entry.items .. ' file(s)'
    end,

    paste = function(entry)
      local paths = entry.created_paths
      if not paths and entry.dir and entry.before then
        paths = {}
        for name in vim.fs.dir(entry.dir) do
          if not entry.before[name] then
            paths[#paths + 1] = entry.dir .. '/' .. name
          end
        end
      end
      if not paths or #paths == 0 then
        return false, 'No pasted files detected'
      end
      local removed = 0
      for _, p in ipairs(paths) do
        if uv.fs_stat(p) then
          vim.fn.delete(p, 'rf')
          Tree:refresh(vim.fs.dirname(p))
          removed = removed + 1
        end
      end
      return true, 'Removed ' .. removed .. ' pasted file(s)'
    end,
  }

  a.explorer_undo = function(picker)
    local entry = history_pop()
    if not entry then
      return Snacks.notify.warn('No explorer operation to undo')
    end

    local ok_u, msg
    local handler = undo_handlers[entry.op]
    if handler then
      ok_u, msg = handler(entry)
    else
      ok_u, msg = false, 'Unknown op: ' .. entry.op
    end

    Actions.update(picker)
    if ok_u then
      Snacks.notify.info('Undo ' .. entry.op .. ': ' .. msg)
    else
      Snacks.notify.error('Undo failed: ' .. msg)
      history_push(entry)
    end
  end

  -- Simple actions ────────────────────────────────────────────
  a.explorer_open_grugfar = with_item_file(function(f)
    Utils.GrugFar.open(vim.fn.fnamemodify(f, ':p'))
  end)
  a.explorer_yank_filename = with_item_file(function(f)
    Utils.copy(vim.fn.fnamemodify(f, ':t:r'))
  end)
  a.explorer_yank_relative_path = with_item_file(function(f)
    Utils.copy(vim.fn.fnamemodify(f, ':.'))
  end)
  a.explorer_yank_absolute_path = with_item_file(function(f)
    Utils.copy(vim.fn.fnamemodify(f, ':p'))
  end)
  a.explorer_list_down = function(picker)
    picker.list:move(8)
  end
  a.explorer_list_up = function(picker)
    picker.list:move(-8)
  end

  -- Width adjustment ──────────────────────────────────────────
  local function resize(picker, delta, lo, hi)
    local win = picker.layout and picker.layout.root and picker.layout.root.win
    if not win then
      return
    end
    local w = math.max(lo, math.min(hi, vim.api.nvim_win_get_width(win) + delta))
    vim.api.nvim_win_set_width(win, w)
    Utils.NvimConfig.set('explorer_width', w)
  end

  a.explorer_wider = function(picker)
    resize(picker, 10, 20, 80)
  end
  a.explorer_narrower = function(picker)
    resize(picker, -10, 20, 80)
  end
end

-- ── Key mappings ────────────────────────────────────────────────
-- stylua: ignore start
local disabled_keys = {
  '<Down>', '<Up>', '<S-CR>', '<S-Tab>',
  '<C-A>', '<C-B>', '<C-D>', '<C-F>', '<C-G>', '<C-J>', '<C-K>',
  '<C-N>', '<C-P>', '<C-Q>', '<C-S>', '<C-T>', '<C-U>', '<C-V>',
  '<C-W>H', '<C-W>J', '<C-W>K', '<C-W>L',
  '<M-D>', '<M-F>', '<M-H>', '<M-I>', '<M-M>', '<M-P>', '<M-W>',
  '<M-d>', '<M-f>', '<M-h>', '<M-i>', '<M-m>', '<M-p>', '<M-w>',
  'j', 'k', 'zb', 'zt', 'zz', '<BS>', 'm', '<c-c>', '<leader>/',
  '<c-t>', '.', 'I', 'H', 'Z', 'q', '<Esc>',
  ']g', '[g', ']d', '[d', ']w', '[w', ']e', '[e',
}
-- stylua: ignore end

local keys = {}
for _, k in ipairs(disabled_keys) do
  keys[k] = false
end

-- stylua: ignore start
local active_keys = {
  ['<leader>'] = 'confirm',                     ['<C-v>'] = 'edit_vsplit',
  ['<C-h>']    = 'edit_split',                  c         = 'explorer_yank',
  o            = 'explorer_open',               h         = 'explorer_close',
  ['/']        = 'toggle_focus',                ['?']     = 'toggle_help_list',
  ['<C-j>']    = 'explorer_list_down',          ['<C-k>'] = 'explorer_list_up',
  i            = 'toggle_ignored',              P         = 'toggle_preview',
  a            = 'explorer_add_undoable',       d         = 'explorer_del_undoable',
  r            = 'explorer_rename_undoable',    p         = 'explorer_paste_undoable',
  x            = 'explorer_move_undoable',      z         = 'explorer_open_grugfar',
  y            = 'explorer_yank_filename',      Y         = 'explorer_yank_relative_path',
  gy           = 'explorer_yank_absolute_path', u         = 'explorer_undo',
  [PluginsKeyMapping.Window.decrease.key] = 'explorer_narrower',
  [PluginsKeyMapping.Window.increase.key] = 'explorer_wider',
}
-- stylua: ignore end
for k, v in pairs(active_keys) do
  keys[k] = v
end

-- ── Explorer state & DirChanged ─────────────────────────────────
local explorer = nil

vim.api.nvim_create_autocmd('DirChanged', {
  callback = function()
    vim.schedule(function()
      if not explorer then
        return
      end
      explorer:set_cwd(Utils.Path.get_project_root())
      explorer:find()
    end)
  end,
})

-- ── Setup ───────────────────────────────────────────────────────
function M.setup()
  ensure_stash_dir()
  if package.loaded['snacks.explorer.actions'] then
    add_actions()
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      once = true,
      callback = function()
        vim.schedule(add_actions)
      end,
    })
  end

  return {
    on_show = function(p)
      Utils.NvimConfig.set('explorer_visible', true)
      explorer = p
    end,
    on_close = function()
      Utils.NvimConfig.set('explorer_visible', false)
      explorer = nil
    end,
    layout = { layout = { width = Utils.NvimConfig.get('explorer_width', 40) } },
    win = {
      input = { title = '', keys = { ['<Esc>'] = { 'toggle_focus', mode = { 'n', 'i' } } } },
      list = { keys = keys },
    },
  }
end

return M
