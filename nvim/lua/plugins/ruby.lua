vim.g.lazyvim_ruby_lsp = "solargraph"
vim.g.lazyvim_ruby_formatter = "rubocop"

return {
  -- this will setup some helpful configs
  { import = "lazyvim.plugins.extras.lang.ruby" },

  -- sets up LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- sorbet for better typechecking
        sorbet = {
          filetypes = { "ruby", "rakefile" },
          cmd = { "srb", "tc", "--lsp", "--no-config" },
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

  -- other plugins
  { "tpope/vim-rails" },
}
