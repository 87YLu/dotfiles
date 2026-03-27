local function augroup(name)
  return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('man_unlisted'),
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

local vim_real_enter = false

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    if vim.g.vscode then
      return
    end

    if vim_real_enter then
      return
    end

    local filetype = vim.bo.filetype

    if filetype == '' or string.match(filetype, '^snacks') then
      return
    end

    vim_real_enter = true

    if Utils.NvimConfig.get('explorer_visible', false) then
      vim.schedule(function()
        Snacks.explorer({ enter = false, cwd = Utils.Path.get_project_root() })
        vim.defer_fn(function()
          vim.cmd('e')
        end, 500)
      end)
    end

    if vim.g.tmux then
      vim.fn.system({ 'tmux', 'rename-window', Utils.Path.get_project_name() })
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    if vim.g.tmux then
      vim.fn.system({ 'tmux', 'rename-window', '' })
      vim.fn.system({ 'tmux', 'set-window-option', 'automatic-rename', 'on' })
    end
  end,
})

local unnecessary_ns = vim.api.nvim_create_namespace('custom_unnecessary')

vim.diagnostic.handlers['unnecessary'] = {
  show = function(_, bufnr, diagnostics, _)
    vim.api.nvim_buf_clear_namespace(bufnr, unnecessary_ns, 0, -1)
    for _, d in ipairs(diagnostics) do
      if d._tags and d._tags.unnecessary then
        pcall(vim.api.nvim_buf_set_extmark, bufnr, unnecessary_ns, d.lnum, d.col, {
          end_row = d.end_lnum,
          end_col = d.end_col,
          hl_group = 'DiagnosticUnnecessary',
          priority = 150,
        })
      end
    end
  end,
  hide = function(_, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, unnecessary_ns, 0, -1)
  end,
}
