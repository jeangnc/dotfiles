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
      { "<leader>of", "<cmd>Neotree ~/.orgfiles<CR>", desc = "Open orgfiles directory" },
      { "<leader>oi", "<cmd>Neorg index<CR>", desc = "Open index norg file" },
      { "<leader>on", "<Plug>(neorg.dirman.new-note)", desc = "Creates a new norg file" },
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
              hook = function(keybinds)
                -- put any keybinds here
              end,
            },
          },
          ["core.integrations.telescope"] = {},
        },
      })
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
    },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources or {}, {
        name = "neorg",
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      defaults = {},
      spec = {
        {
          { "<leader>o", group = "orgmode" },
        },
      },
    },
  },
}
