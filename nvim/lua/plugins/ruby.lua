return {
  { "tpope/vim-rails" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "erb-formatter",
        "erb-lint",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          enabled = true,
          mason = false,
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
        },

        rubocop = {
          mason = false,
          enabled = true,
          cmd = { "bundle", "exec", "rubocop", "--lsp", "--force-exclusion" },
          init_options = {
            lint = {
              rubocop = {
                enabled = false,
              },
            },
          },
        },
      },
    },
  },
}
