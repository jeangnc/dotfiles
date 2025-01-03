return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = { enabled = false },
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
      terminal = {
        win = {
          position = "float",
        },
      },
    },
  },
}
