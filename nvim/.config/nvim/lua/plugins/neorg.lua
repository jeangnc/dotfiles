local function neorg_fn(name)
  return function()
    require("utils.neorg")[name]()
  end
end

return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    opts = {
      rocks = { "tree-sitter-norg" },
    },
  },
  {
    "nvim-neorg/neorg",
    ft = "norg", -- Load when opening .norg files
    cmd = "Neorg", -- Load when running Neorg commands
    branch = "main",
    dependencies = {
      { "luarocks.nvim" },
      { "benlubas/neorg-interim-ls" }, -- Required by neorg-archive for external.refactor module
      { "benlubas/neorg-conceal-wrap" },
      { "bottd/neorg-archive" }, -- Depends on neorg-interim-ls
      { "max397574/neorg-contexts" },
      { "phenax/neorg-hop-extras" },
      { "jeangnc/neorg-indent" },

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
      { "<leader>on", neorg_fn("create_note_with_template"), desc = "Create new note (with template)" },
      { "<leader>or", "<cmd>Neorg return<cr>", desc = "Closes all Neorg-related buffers" },

      -- File navigation & search
      { "<leader>oe", neorg_fn("explore_workspace"), desc = "Explore Neorg files (workspace)" },
      { "<leader>o<space>", neorg_fn("search_files"), desc = "Search Neorg files (workspace)" },
      { "<leader>o0", neorg_fn("search_content"), desc = "Live grep Neorg files (workspace)" },

      -- Journal operations
      { "<leader>oje", neorg_fn("explore_journal"), desc = "Explore journal files (workspace)" },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
    },
    config = function()
      local neorg_utils = require("utils.neorg")
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

          ["external.indent"] = {
            config = {
              indent_per_level = 4,
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
