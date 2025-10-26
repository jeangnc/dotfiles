return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "graphql-language-service-cli",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        "graphql",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "graphql",
      },
    },
  },
}
