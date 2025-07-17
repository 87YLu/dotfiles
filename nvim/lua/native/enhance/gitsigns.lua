-- https://github.com/lewis6991/gitsigns.nvim
return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  config = function()
    require('gitsigns').setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        local keys = require('native.basic.keymaps').gitsigns

        map('n', keys.prev_hunk, function()
          if vim.wo.diff then
            return keys.prev_hunk
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'prev hunk' })

        map('n', keys.next_hunk, function()
          if vim.wo.diff then
            return keys.next_hunk
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'next hunk' })
        map('n', keys.stage_hunk, gs.stage_hunk, { desc = 'stage hunk' })
        map('n', keys.undo_hunk, gs.undo_stage_hunk, { desc = 'undo hunk' })
        map('n', keys.hunk_preview, gs.preview_hunk, { desc = 'hunk preview' })
      end,
    })
  end,
}
