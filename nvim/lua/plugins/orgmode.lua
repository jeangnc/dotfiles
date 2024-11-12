-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

vim.keymap.set("n", "<leader>of", function()
  open_context("~/.orgfiles")
end, { desc = "Opens orgfiles directory", silent = true, noremap = true })

vim.keymap.set(
  "n",
  "<leader>oi",
  "<cmd>Neorg index<cr>",
  { desc = "Opens neorg index file", silent = true, noremap = true }
)

vim.keymap.set(
  "n",
  "<leader>on",
  "<Plug>(neorg.dirman.new-note)",
  { desc = "Creates a new norg file", silent = true, noremap = true }
)

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
            },
          },
          ["core.integrations.telescope"] = {},
          ["core.summary"] = {},
        },
      })

      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "norg",
        callback = function()
          vim.keymap.set(
            { "n", "v", "o" },
            "]h",
            "<Plug>(neorg.treesitter.next.heading)",
            { desc = "Go to next heading", buffer = true }
          )
          vim.keymap.set(
            { "n", "v", "o" },
            "[h",
            "<Plug>(neorg.treesitter.previous.heading)",
            { desc = "Go to next heading", buffer = true }
          )
          vim.keymap.set(
            { "n" },
            "<localleader>am",
            "<cmd>Neorg inject-metadata<cr>",
            { desc = "Inject metadata", buffer = true }
          )
        end,
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
          { "<localleader>a", group = "Append" },
        },
      },
    },
  },
}
