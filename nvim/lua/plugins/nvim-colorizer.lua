return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  opts = {
    parsers = {
      rgb = { enable = true },
      hsl = { enable = true },
    },
  },
}
