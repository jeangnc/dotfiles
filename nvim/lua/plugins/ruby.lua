return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },
  -- mason for erb formatting
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "erb-formatter", "erb-lint" },
    },
  },
  -- sets up LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- sorbet for better typechecking
        sorbet = {
          filetypes = { "ruby", "rakefile" },
          cmd = { "srb", "tc", "--lsp", "--typed=true", "--no-config", "." },
        },
        -- solargraph for linting
        solargraph = {
          enabled = true,
          filetypes = { "ruby", "rakefile" },
          settings = {
            solargraph = {
              diagnostics = true,
              definitions = false,
            },
          },
        },
      },
    },
  },
}
