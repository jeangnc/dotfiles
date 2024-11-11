return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },
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
          cmd = { "srb", "tc", "--lsp", "--typed=true", "--no-config" },
          settings = {},
          init_options = {
            formatting = false,
          },
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

  { "tpope/vim-rails" },
}
