vim.g.lazyvim_ruby_lsp = "solargraph"
vim.g.lazyvim_ruby_formatter = "rubocop"

return {
  { import = "lazyvim.plugins.extras.lang.ruby" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
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
      },
    },
  },
}
