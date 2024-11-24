-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

return {
  {
    "nvim-neorg/neorg",
    lazy = true,
    cmd = "Neorg",
    keys = {
      { "<leader>owp", "<cmd>Neorg workspace personal<cr>", desc = "Personal" },
      { "<leader>oww", "<cmd>Neorg workspace work<cr>", desc = "Work" },
      { "<leader>oe", "<cmd>Telescope neorg find_norg_files<cr>", desc = "Explore Neorg files" },
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Opens workspace's index file" },
      { "<leader>or", "<cmd>Neorg return<cr>", desc = "Closes all Neorg-related buffers" },
      { "<leader>on", "<Plug>(neorg.dirman.new-note)", desc = "Creates a new norg file" },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
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
                main = "~/.orgfiles/main",
                work = "~/.orgfiles/work",
                personal = "~/.orgfiles/personal",
              },
              default_workspace = "work",
            },
          },
          ["core.journal"] = {
            config = {
              journal_folder = ".journalfiles",
              strategy = "flat",
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
            "<F12>",
            "<cmd>Neorg toggle-concealer<cr>",
            { desc = "Toggle concealer", buffer = true }
          )
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
          vim.keymap.set({ "n" }, "<A-Enter>", function()
            vim.cmd("startinsert")
            vim.cmd('lua require("neorg.modules.core.itero.module").public.next_iteration_cr()')
          end, { desc = "", buffer = true })

          -- indents the file after leaving insert mode
          vim.api.nvim_create_autocmd("InsertLeave", {
            buffer = 0, -- Limit this autocmd to the current buffer
            callback = function()
              local current_pos = vim.api.nvim_win_get_cursor(0) -- Get the current cursor position
              vim.cmd("silent normal! gg=G") -- Indent the entire file
              vim.api.nvim_win_set_cursor(0, current_pos) -- Restore the cursor position
            end,
          })
        end,
      })
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "norg" },
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
          { "<leader>o", group = "orgmode", icon = " " },
          { "<leader>ow", group = "workspaces", icon = " " },
          { "<leader>oj", group = "journal", icon = " " },
          { "<localleader>a", group = "Append" },
        },
      },
    },
  },
}
