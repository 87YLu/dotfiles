-- https://github.com/sindrets/diffview.nvim
return {
  'sindrets/diffview.nvim',
  event = 'VeryLazy',
  config = function()
    local is_diffview_opening = false
    local diffview = require('diffview')
    local file_utils = require('native.utils.file')

    function Open_file_at_diffview_panel()
      local lib = require('diffview.lib')
      local file = lib.get_current_view():infer_cur_file()

      if not file then
        return
      end

      if file_utils.is_exist(file.path) then
        vim.cmd('DiffviewClose')
        vim.cmd(':e ' .. file.path)
      else
        vim.notify('the file has been deleted.')
      end
    end

    diffview.setup({
      hooks = {
        view_opened = function()
          is_diffview_opening = true
        end,
        view_closed = function()
          is_diffview_opening = false
        end,
        diff_buf_read = function(bufnr)
          local is_diffview = string.sub(file_utils.current_path(), 1, string.len('diffview://')) == 'diffview://'

          if is_diffview then
            vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
          end

          vim.opt_local.foldlevel = 99
          vim.opt_local.foldenable = false
        end,
        diff_buf_win_enter = function(bufnr, ctx)
          vim.opt_local.foldlevel = 99
          vim.opt_local.foldenable = false
        end,
      },
      keymaps = {
        file_panel = {
          { 'n', 'o', Open_file_at_diffview_panel, { desc = 'open file' } },
          { 'n', 'gf', function() end },
        },
      },
    })

    local action = function(cmd)
      return function()
        if is_diffview_opening then
          vim.cmd('DiffviewClose')
        else
          vim.cmd(cmd)
        end
      end
    end

    local keys = require('native.basic.keymaps').diffview

    vim.g.keyset('n', keys.file_diff, action('DiffviewOpen'), { desc = 'view file diff' })
    vim.g.keyset('n', keys.file_history, action('DiffviewFileHistory %'), { desc = 'view file history' })
    vim.g.keyset('n', keys.git_history, action('DiffviewFileHistory'), { desc = 'view git history' })
  end,
}
