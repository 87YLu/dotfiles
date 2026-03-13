local initSnacks = function()
  if vim.g.vscode then
    return
  end
  local map = vim.keymap.set
  -- buffer
  local bufferKeys = PluginsKeyMapping.Snacks.buffer
  map('n', bufferKeys.delete.key, function()
    Snacks.bufdelete()
  end, { desc = bufferKeys.delete.desc })
  map('n', bufferKeys.deleteOther.key, function()
    Snacks.bufdelete.other()
  end, { desc = bufferKeys.deleteOther.desc })

  -- code
  local codeKeys = PluginsKeyMapping.Snacks.code
  map('n', codeKeys.bufferDiagnostics.key, function()
    Snacks.picker.diagnostics_buffer()
  end, { desc = codeKeys.bufferDiagnostics.desc })

  -- git
  local gitKeys = PluginsKeyMapping.Snacks.git
  map('n', gitKeys.lazygit.key, function()
    Snacks.lazygit({
      cwd = Utils.Path.get_project_root(),
      win = {
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
      },
    })
  end, { desc = gitKeys.lazygit.desc })
  map({ 'n', 'x' }, gitKeys.browser.key, function()
    Snacks.gitbrowse()
  end, { desc = gitKeys.browser.desc })

  -- find
  local findKeys = PluginsKeyMapping.Snacks.find
  map('n', findKeys.buffer.key, function()
    Snacks.picker.buffers()
  end, { desc = findKeys.buffer.desc })
  map('n', findKeys.recent.key, function()
    Snacks.picker.recent({ filter = { cwd = Utils.Path.get_project_root() } })
  end, { desc = findKeys.recent.desc })
  map('n', findKeys.file.key, function()
    Snacks.picker.files({ cwd = Utils.Path.get_project_root() })
  end, { desc = findKeys.file.desc })
  map('n', findKeys.explorer.key, function()
    Snacks.explorer({
      layout = {
        layout = {
          width = Utils.NvimConfig.get('explorer_width', 40),
        },
      },
      cwd = Utils.Path.get_project_root(),
    })
  end, { desc = findKeys.explorer.desc })

  -- search
  local searchKeys = PluginsKeyMapping.Snacks.search
  map('n', searchKeys.grep.key, function()
    Snacks.picker.grep({ cwd = Utils.Path.get_project_root() })
  end, { desc = searchKeys.grep.desc })
  map('n', searchKeys.resume.key, function()
    Snacks.picker.resume()
  end, { desc = searchKeys.resume.desc })

  -- terminal
  local terminalKeys = PluginsKeyMapping.Snacks.terminal
  vim.keymap.set('n', terminalKeys.open.key, function()
    Snacks.terminal(nil, {
      cwd = Utils.Path.get_git_root(),
      win = {
        width = math.floor(vim.o.columns * 0.5),
        height = math.floor(vim.o.lines * 0.5),
      },
    })
  end, {
    desc = terminalKeys.open.desc,
  })

  -- ui toggle
  local uiToggleKeys = PluginsKeyMapping.Snacks.uiToggle
  Snacks.toggle({
    name = uiToggleKeys.backgroundTransparent.desc,
    get = function()
      return Utils.NvimConfig.get('background_transparent', true)
    end,
    set = function(enabled)
      Utils.NvimConfig.set('background_transparent', enabled)
      Utils.Colorscheme.reset()
    end,
  }):map(uiToggleKeys.backgroundTransparent.key)
  Snacks.toggle({
    name = uiToggleKeys.darkMode.desc,
    get = function()
      return Utils.NvimConfig.get('darkmode', true)
    end,
    set = function(enabled)
      Utils.NvimConfig.set('darkmode', enabled)
      vim.o.background = enabled and 'dark' or 'light'
      Utils.Colorscheme.reset()
    end,
  }):map(uiToggleKeys.darkMode.key)
  Snacks.toggle({
    name = uiToggleKeys.inlayHint.desc,
    get = function()
      return Utils.NvimConfig.get('inlay_hint', true)
    end,
    set = function(enabled)
      Utils.NvimConfig.set('inlay_hint', enabled)
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then
          vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
        end
      end
    end,
  }):map(uiToggleKeys.inlayHint.key)
  Snacks.toggle({
    name = uiToggleKeys.virtualText.desc,
    get = function()
      return Utils.NvimConfig.get('virtual_text', true)
    end,
    set = function(enabled)
      Utils.NvimConfig.set('virtual_text', enabled)
      vim.diagnostic.config({ virtual_text = enabled and VirtualText or false })
    end,
  }):map(uiToggleKeys.virtualText.key)
  Snacks.toggle({
    name = uiToggleKeys.lspUnderline.desc,
    get = function()
      return Utils.NvimConfig.get('lsp_underline', true)
    end,
    set = function(enabled)
      Utils.NvimConfig.set('lsp_underline', enabled)
      vim.diagnostic.config({ underline = enabled })
    end,
  }):map(uiToggleKeys.lspUnderline.key)
end

local function get_projects()
  local uv = vim.uv or vim.loop
  local sessions = vim.fn.glob(Utils.Path.get_session_path() .. '*.vim', true, true)
  local home = uv.os_homedir and uv.os_homedir() or vim.loop.os_homedir()

  local function mtime(path)
    local stat = uv.fs_stat(path)
    return stat and stat.mtime and stat.mtime.sec or 0
  end

  table.sort(sessions, function(a, b)
    return mtime(a) > mtime(b)
  end)

  local items = {}
  local have = {}

  for _, session in ipairs(sessions) do
    if uv.fs_stat(session) then
      local file = session:sub(#Utils.Path.get_session_path() + 1, -5)
      local dir = file:gsub('%%', '/')
      if not have[dir] then
        have[dir] = true

        if Utils.Path.is_exist(dir) and (dir ~= home) then
          table.insert(items, vim.fn.fnamemodify(dir, ':p:~'))
        end
      end
    end
  end

  return items
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    scroll = { enabled = not vim.g.vscode },
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        header = Utils.Dashboard.get_header(),
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'p', desc = 'Projects', action = ":lua Snacks.dashboard.pick('projects')" },
          {
            icon = ' ',
            key = 'c',
            desc = 'Config',
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header', pane = 2 },
        {
          { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
          {
            icon = ' ',
            title = 'Projects',
            section = 'projects',
            indent = 2,
            padding = 1,
            dirs = get_projects(),
            limit = 10,
          },
          { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { section = 'startup' },
        },
      },
    },
    indent = { enabled = false },
    styles = {
      help = {
        border = 'rounded',
      },
    },
    picker = {
      sources = {
        explorer = require('plugins.snacks-explorer').setup(),
      },
    },
    input = {
      win = {
        relative = 'editor',
        width = 0.5,
        min_width = 60,
        max_width = 100,
        row = math.floor(vim.o.lines * 0.35),
      },
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      win = {
        style = 'float',
        border = 'rounded',
      },
    },
    image = Utils.Image.snack_image,
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        initSnacks()
      end,
    })
  end,
}
