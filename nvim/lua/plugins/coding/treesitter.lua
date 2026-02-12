local TreesitterUtils = {}

TreesitterUtils._installed = nil
TreesitterUtils._queries = {}

function TreesitterUtils.get_installed(update)
  if update then
    TreesitterUtils._installed, TreesitterUtils._queries = {}, {}
    for _, lang in ipairs(require('nvim-treesitter').get_installed('parsers')) do
      TreesitterUtils._installed[lang] = true
    end
  end
  return TreesitterUtils._installed or {}
end

function TreesitterUtils.have_query(lang, query)
  local key = lang .. ':' .. query
  if TreesitterUtils._queries[key] == nil then
    TreesitterUtils._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return TreesitterUtils._queries[key]
end

function TreesitterUtils.have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == 'number' and vim.bo[what].filetype or what --[[@as string]]
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil or TreesitterUtils.get_installed()[lang] == nil then
    return false
  end
  if query and not TreesitterUtils.have_query(lang, query) then
    return false
  end
  return true
end

function TreesitterUtils.check()
  local function have(tool)
    return vim.fn.executable(tool) == 1
  end

  local ret = {
    ['tree-sitter (CLI)'] = have('tree-sitter'),
    tar = have('tar'),
    curl = have('curl'),
  }
  local ok = true
  for _, v in pairs(ret) do
    ok = ok and v
  end
  return ok, ret
end

function TreesitterUtils.build(cb)
  TreesitterUtils.ensure_treesitter_cli(function(_, err)
    local ok, health = TreesitterUtils.check()
    if ok then
      return cb()
    else
      local lines = { 'Unmet requirements for **nvim-treesitter** `main`:' }
      local keys = vim.tbl_keys(health) ---@type string[]
      table.sort(keys)
      for _, k in pairs(keys) do
        lines[#lines + 1] = ('- %s `%s`'):format(health[k] and '✅' or '❌', k)
      end
      vim.list_extend(lines, {
        '',
        'See the requirements at [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements)',
        'Run `:checkhealth nvim-treesitter` for more information.',
      })
      if vim.fn.has('win32') == 1 and not health['C compiler'] then
        lines[#lines + 1] = 'Install a C compiler with `winget install --id=BrechtSanders.WinLibs.POSIX.UCRT -e`'
      end
      vim.list_extend(lines, err and { '', err } or {})
    end
  end)
end

function TreesitterUtils.ensure_treesitter_cli(cb)
  if vim.fn.executable('tree-sitter') == 1 then
    return cb(true)
  end

  local mr = require('mason-registry')
  mr.refresh(function()
    local p = mr.get_package('tree-sitter-cli')
    if not p:is_installed() then
      vim.notify('Installing `tree-sitter-cli` with `mason.nvim`...')
      p:install(
        nil,
        vim.schedule_wrap(function(success)
          if success then
            vim.notify('Installed `tree-sitter-cli` with `mason.nvim`.')
            cb(true)
          else
            cb(false, 'Failed to install `tree-sitter-cli` with `mason.nvim`.')
          end
        end)
      )
    else
      cb(true)
    end
  end)
end

_G.TreesitterUtils = {
  foldexpr = function()
    return TreesitterUtils.have(nil, 'folds') and vim.treesitter.foldexpr() or '0'
  end,
  indentexpr = function()
    return TreesitterUtils.have(nil, 'indents') and require('nvim-treesitter').indentexpr() or -1
  end,
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    version = false,
    build = function()
      local TS = require('nvim-treesitter')
      TreesitterUtils.build(function()
        TS.update(nil, { summary = true })
      end)
    end,
    event = { 'LazyFile', 'VeryLazy' },
    lazy = false,
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    dependencies = vim.g.vscode and {} or {
      'hiphish/rainbow-delimiters.nvim',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
    },
    opts = {
      highlight = { enable = not vim.g.vscode },
      -- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
      ensure_installed = {
        'bash',
        'css',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'rust',
        'scss',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'xml',
        'yaml',
      },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter')

      TS.setup(opts)

      TreesitterUtils.get_installed(true)

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not TreesitterUtils.have(lang)
      end, opts.ensure_installed or {})

      if #install > 0 then
        TreesitterUtils.build(function()
          TS.install(install, { summary = true }):await(function()
            TreesitterUtils.get_installed(true) -- refresh the installed langs
          end)
        end)
      end

      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not TreesitterUtils.have(ft) then
            return
          end

          local function enabled(feat, query)
            local f = opts[feat] or {}
            return f.enable ~= false
              and not (type(f.disable) == 'table' and vim.tbl_contains(f.disable, lang))
              and TreesitterUtils.have(ft, query)
          end

          -- -- highlighting
          if enabled('highlight', 'highlights') then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if enabled('indent', 'indents') then
            Utils.set_default('indentexpr', 'v:lua.TreesitterUtils.indentexpr()')
          end

          -- folds
          if enabled('folds', 'folds') then
            if Utils.set_default('foldmethod', 'expr') then
              Utils.set_default('foldexpr', 'v:lua.TreesitterUtils.foldexpr()')
            end
          end
        end,
      })

      if not vim.g.vscode then
        local rainbow_delimiters = require('rainbow-delimiters')

        require('ts_context_commentstring').setup({})

        -- https://github.com/hiphish/rainbow-delimiters.nvim
        vim.g.rainbow_delimiters = {
          strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local'],
          },
          query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
          },
          highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
          },
        }
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {
      move = {
        enable = true,
        set_jumps = true,
        keys = {
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
      },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter-textobjects')
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not (vim.tbl_get(opts, 'move', 'enable') and TreesitterUtils.have(ft, 'textobjects')) then
          return
        end
        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, 'move', 'keys') or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == 'table' and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub('@', ''):gsub('%..*', '')
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, ' or ')
            desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
            if not (vim.wo.diff and key:find('[cC]')) then
              vim.keymap.set({ 'n', 'x', 'o' }, key, function()
                require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
              end, {
                buffer = buf,
                desc = desc,
                silent = true,
              })
            end
          end
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_textobjects', { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },
}
