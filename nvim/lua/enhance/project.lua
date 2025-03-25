-- https://github.com/ahmedkhalf/project.nvim
return {
  'ahmedkhalf/project.nvim',
  event = 'VeryLazy',
  config = function()
    require('project_nvim').setup({
      detection_methods = { 'pattern' },
      -- 可能是 monorepo，所以不添加 package.json
      patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'Cargo.toml', '.sln' },
    })

    local has_telescope, telescope = pcall(require, 'telescope')

    if has_telescope then
      pcall(telescope.load_extension, 'projects')
    end
  end,
}
