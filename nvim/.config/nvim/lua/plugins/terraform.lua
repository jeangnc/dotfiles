return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "hcl" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "terraform-ls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          enabled = true,
        },
      },
    },
  },
}
