return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
      icons = {
        diagnostics = {
          -- Error = "",
          -- Warn = "",
          -- Hint = "",
          -- Info = "",
        },
      },
    },
  },
}
