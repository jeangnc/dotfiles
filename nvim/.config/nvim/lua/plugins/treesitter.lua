return {
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "main",
    opts = {
      incremental_selection = {
        enable = false,
      },
      -- Disable auto-install to prevent corruption issues
      auto_install = false,
      -- Skip problematic parsers
      ignore_install = { "jsonc" },
    },
  },
}
