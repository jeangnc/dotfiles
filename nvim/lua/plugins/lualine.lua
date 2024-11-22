return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_b = {},
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = {},
    },
  },
}
