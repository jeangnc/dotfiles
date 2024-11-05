vim.g.lazyvim_ruby_lsp = "solargraph"
vim.g.lazyvim_ruby_formatter = "rubocop"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
          filetypes = { "ruby", "rakefile" },
          root_dir = function(fname)
            return require("lspconfig").util.root_pattern("Gemfile", ".git", ".")(fname)
          end,
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
  { import = "lazyvim.plugins.extras.lang.ruby" },
}
