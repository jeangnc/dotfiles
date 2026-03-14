return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "catppuccin/nvim" },
  opts = {
    options = {
      theme = "catppuccin-mocha",
    },
    sections = {
      lualine_b = {},
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = {},
    },
  },
}
