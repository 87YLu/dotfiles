return {
  'lewis6991/gitsigns.nvim',
  event = 'LazyFile',
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 0,
    },
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    preview_config = {
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      local GitSignsKeys = PluginsKeyMapping.GitSigns
      map('n', GitSignsKeys.nextHunk.key, function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, GitSignsKeys.nextHunk.key)
      map('n', GitSignsKeys.prevHunk.key, function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, GitSignsKeys.prevHunk.desc)
      map({ 'n', 'x' }, GitSignsKeys.stageHunk.key, ':Gitsigns stage_hunk<CR>', GitSignsKeys.stageHunk.desc)
      map({ 'n', 'x' }, GitSignsKeys.resetHunk.key, ':Gitsigns reset_hunk<CR>', GitSignsKeys.resetHunk.desc)
      map('n', GitSignsKeys.undoStageHunk.key, gs.undo_stage_hunk, GitSignsKeys.undoStageHunk.desc)
      map('n', GitSignsKeys.previewHunk.key, gs.preview_hunk, GitSignsKeys.previewHunk.desc)
      map({ 'o', 'x' }, GitSignsKeys.selectHunk.key, ':<C-U>Gitsigns select_hunk<CR>', GitSignsKeys.selectHunk.desc)
    end,
  },
}

