-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

local neorg_utils = require("utils.neorg")

return {
  {
    "nvim-neorg/neorg",
    lazy = true,
    ft = "norg",
    cmd = "Neorg",
    dependencies = {
      { "benlubas/neorg-conceal-wrap" },
      { "benlubas/neorg-interim-ls" },
      { "bottd/neorg-archive" },
      { "max397574/neorg-contexts" },
      { "phenax/neorg-hop-extras" },

      -- required by most plugins
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      -- Workspace management
      { "<leader>owp", "<cmd>Neorg workspace personal<cr>", desc = "Personal" },
      { "<leader>oww", "<cmd>Neorg workspace work<cr>", desc = "Work" },

      -- File operations
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Opens workspace's index file" },
      {
        "<leader>on",
        function()
          neorg_utils.create_note_with_template()
        end,
        desc = "Create new note (with template)",
      },
      { "<leader>or", "<cmd>Neorg return<cr>", desc = "Closes all Neorg-related buffers" },

      -- File navigation & search
      {
        "<leader>oe",
        function()
          neorg_utils.neotree_explore(neorg_utils.current_workspace_dir())
        end,
        desc = "Explore Neorg files (workspace)",
      },
      {
        "<leader>o<space>",
        function()
          neorg_utils.fzf_files(neorg_utils.current_workspace_dir())
        end,
        desc = "Search Neorg files (workspace)",
      },
      {
        "<leader>o0",
        function()
          neorg_utils.fzf_grep(neorg_utils.current_workspace_dir())
        end,
        desc = "Live grep Neorg files (workspace)",
      },

      -- Journal operations
      {
        "<leader>oje",
        function()
          neorg_utils.neotree_explore(neorg_utils.current_workspace_dir() .. "/**/.journalfiles")
        end,
        desc = "Explore journal files (workspace)",
      },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
    },
    config = function()
      require("neorg").setup({
        load = {
          -- Core modules
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.export"] = {},
          ["core.summary"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
            },
          },
          ["core.itero"] = {
            config = {
              iterables = {
                "unordered_list%d",
                "ordered_list%d",
                "quote%d",
              },
            },
          },
          ["core.completion"] = {
            config = {
              engine = {
                module_name = "external.lsp-completion",
              },
            },
          },
          ["core.dirman"] = {
            config = {
              use_popup = false,
              open_buffers_in_workspace = false,
              autochdir = false,
              workspaces = {
                work = "~/.orgfiles/workspaces/work",
                personal = "~/.orgfiles/workspaces/personal",
                archive = "~/.orgfiles/workspaces/archive",
              },
              default_workspace = neorg_utils.get_default_workspace,
            },
          },
          ["core.journal"] = {
            config = {
              journal_folder = ".journalfiles",
              default_workspace = neorg_utils.get_default_workspace,
            },
          },

          -- External plugins
          ["external.interim-ls"] = {
            config = {
              completion_provider = {
                enable = true,
                documentation = true,
                categories = false,
                people = {
                  enable = false,
                  path = "people",
                },
              },
            },
          },
          ["external.archive"] = {
            config = {
              workspace = "archive",
              confirm = true,
            },
          },
          ["external.conceal-wrap"] = {},
          ["external.context"] = {},
          ["external.hop-extras"] = {
            config = {
              bind_enter_key = false,
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "norg" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>o", group = "orgmode", icon = "🧠" },
        { "<leader>ow", group = "workspaces", icon = " " },
        { "<leader>oj", group = "journal", icon = "📓" },
      },
    },
  },
}
