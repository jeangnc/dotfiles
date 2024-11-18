-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

local function first_day_of_week(date)
  local currentDayOfWeek = os.date("*t", date).wday
  local daysToSubtract = currentDayOfWeek - 1
  local firstDayOfWeek = os.date("*t", date - (daysToSubtract * 86400))
  return string.format("%04d-%02d-%02d", firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day)
end

return {
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    keys = {
      { "<leader>owe", "<cmd>Neorg workspace<cr>", desc = "Explore workspaces" },
      { "<leader>oe", "<cmd>Telescope neorg find_norg_files<cr>", desc = "Explore Neorg files" },
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Opens workspace's index file" },
      { "<leader>on", "<Plug>(neorg.dirman.new-note)", desc = "Creates a new norg file" },
      { "<leader>ojdp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojdc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojdn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
      {
        "<leader>ojwc",
        function()
          vim.cmd("Neorg journal custom " .. first_day_of_week(os.time()))
        end,
        desc = "Open current week's journal",
      },
      {
        "<leader>ojwp",
        function()
          vim.cmd("Neorg journal custom " .. first_day_of_week(os.time() - 7 * 86400))
        end,
        desc = "Open previous week's journal",
      },
      {
        "<leader>ojwn",
        function()
          vim.cmd("Neorg journal custom " .. first_day_of_week(os.time() - 7 * 86400))
        end,
        desc = "Open next week's journal",
      },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
      -- {
      --   "<leader>ojwc",
      --   function()
      --     vim.cmd("Neorg journal custom " .. first_day_of_week(os.time()))
      --   end,
      --   desc = "Open current week's journal",
      -- },
      -- {
      --   "<leader>ojwp",
      --   function()
      --     vim.cmd("Neorg journal custom " .. first_day_of_week(os.time() - 7 * 86400))
      --   end,
      --   desc = "Open previous week's journal",
      -- },
      -- {
      --   "<leader>ojwn",
      --   function()
      --     vim.cmd("Neorg journal custom " .. first_day_of_week(os.time() - 7 * 86400))
      --   end,
      --   desc = "Open next week's journal",
      -- },
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
          vim.keymap.set({ "n" }, "<Enter>", function()
            vim.cmd("startinsert")
            vim.cmd('lua require("neorg.modules.core.itero.module").public.next_iteration_cr()')
          end, { desc = "", buffer = true })
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
          { "<leader>ojd", group = "Day" },
          { "<leader>ojw", group = "Week" },
          -- { "<leader>ojd", group = "Day" },
          -- { "<leader>ojw", group = "Week" },
          { "<localleader>a", group = "Append" },
        },
      },
    },
  },
}
