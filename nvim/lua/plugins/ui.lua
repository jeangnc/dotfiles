return {
  {
    "folke/noice.nvim",
    opts = {
      messages = {
        timeout = 10000, -- Set the display time to 5000 milliseconds (5 seconds)
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
}
