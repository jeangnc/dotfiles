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
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- solargraph to enable go to definition
        solargraph = {
          enabled = true,
          filetypes = { "ruby", "rakefile" },
          settings = {
            solargraph = {
              autoformat = true,
              completion = true,
              diagnostic = true,
              folding = true,
              references = true,
              rename = true,
              symbols = true,
            },
          },
        },
        sorbet = {
          cmd = { "srb", "tc", "--lsp", "--typed=true", "--no-config", "." },
        },
      },
    },
  },
}
