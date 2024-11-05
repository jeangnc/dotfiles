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
