-- https://github.com/ahmedkhalf/project.nvim
local status_ok, project = pcall(require, 'project_nvim')

if not status_ok then
  vim.notify('project_nvim not found!')
  return
end

project.setup({
  detection_methods = { 'pattern' },
  -- because there may be monorepo, package.json is not added.
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'Cargo.toml', '.sln' },
})

local status, telescope = pcall(require, 'telescope')

if not status then
  vim.notify('telescope not found!')
  return
end

pcall(telescope.load_extension, 'projects')
