-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

local function current_workspace_dir()
  local dirman = require("neorg").modules.get_module("core.dirman")
  local current_workspace = dirman.get_current_workspace()

  if current_workspace then
    return tostring(current_workspace[2])
  end
end

local function fzf_explore(folder)
  if not folder then
    return
  end

  local opts = {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
    cwd = folder,
  }

  require("fzf-lua").files(opts)
end

return {
  {
    "nvim-neorg/neorg",
    lazy = true,
    ft = "norg",
    cmd = "Neorg",
    keys = {
      { "<leader>owp", "<cmd>Neorg workspace personal<cr>", desc = "Personal" },
      { "<leader>oww", "<cmd>Neorg workspace work<cr>", desc = "Work" },
      {
        "<leader>oe",
        function()
          fzf_explore("~/.orgfiles")
        end,
        desc = "Explore Neorg files (root dir)",
      },
      {
        "<leader>oE",
        function()
          fzf_explore(current_workspace_dir())
        end,
        desc = "Explore Neorg files (workspace)",
      },
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Opens workspace's index file" },
      { "<leader>or", "<cmd>Neorg return<cr>", desc = "Closes all Neorg-related buffers" },
      { "<leader>on", "<Plug>(neorg.dirman.new-note)", desc = "Creates a new norg file" },
      {
        "<leader>oje",
        function()
          fzf_explore(current_workspace_dir() .. "/**/.journalfiles")
        end,
        desc = "Explore journal files (workspace)",
      },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "pritchett/neorg-capture" },
      { "benlubas/neorg-conceal-wrap" },
      { "benlubas/neorg-interim-ls" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.export"] = {},
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
          ["core.summary"] = {},

          -- external plugins
          ["external.conceal-wrap"] = {},
          -- ["external.interim-ls"] = {
          --   config = {
          --     -- default config shown
          --     completion_provider = {
          --       -- Enable or disable the completion provider
          --       enable = true,
          --
          --       -- Show file contents as documentation when you complete a file name
          --       documentation = true,
          --
          --       -- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
          --       categories = false,
          --     },
          --   },
          -- },
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
            { "n" },
            "<localleader>am",
            "<cmd>Neorg inject-metadata<cr>",
            { desc = "Inject metadata", buffer = true }
          )

          vim.keymap.set({ "n", "i", "o" }, "<Tab>", function()
            vim.cmd("startinsert")
            vim.cmd('lua require("neorg.modules.core.itero.module").public.next_iteration_cr()')
          end, { desc = "", buffer = true })
        end,
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
