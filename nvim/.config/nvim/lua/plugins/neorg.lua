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
      { "<leader>owa", "<cmd>Neorg workspace archive<cr>", desc = "Archive" },

      -- File operations
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Opens workspace's index file" },
      { "<leader>on", neorg_utils.create_note_with_template, desc = "Create new note (with template)" },
      { "<leader>or", "<cmd>Neorg return<cr>", desc = "Closes all Neorg-related buffers" },

      -- File navigation & search
      { "<leader>oe", neorg_utils.explore_workspace, desc = "Explore Neorg files (workspace)" },
      { "<leader>o<space>", neorg_utils.search_files, desc = "Search Neorg files (workspace)" },
      { "<leader>o0", neorg_utils.search_content, desc = "Live grep Neorg files (workspace)" },

      -- Journal operations
      { "<leader>oje", neorg_utils.explore_journal, desc = "Explore journal files (workspace)" },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },

      -- Edit quirks
      { "<localleader><tab>", "<cmd>Neorg toc<cr>", desc = "Opens Table of Content" },
      { "<localleader>am", "<cmd>Neorg inject-metadata<cr>", desc = "Inject metadata", buffer = true },
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
