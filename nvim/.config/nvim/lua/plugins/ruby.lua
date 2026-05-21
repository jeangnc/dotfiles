return {
  { "tpope/vim-rails", ft = { "ruby", "eruby", "rake" } },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "erb-formatter",
        "erb-lint",
        "ruby-lsp",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          enabled = true,
          mason = true,
        },
      },
    },
  },
}
