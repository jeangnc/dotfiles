-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

return {
  -- Add Neorg plugin
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "norg" },
    },
  },
  {
    "nvim-neorg/neorg",
    keys = {
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Open index norg file" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                main = "~/.orgfiles",
              },
              default_workspace = "main",
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              hook = function(keybinds) end,
            },
          },
        },
      })
    end,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources or {}, {
        name = "neorg",
      })
    end,
  },
}
