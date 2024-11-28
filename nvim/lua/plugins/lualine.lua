return {
  "nvim-lualine/lualine.nvim",
  opts = {
    theme = "catppuccin",
    options = {
      theme = "catppuccin",
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
