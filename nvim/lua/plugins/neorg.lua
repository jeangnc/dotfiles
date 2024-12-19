-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

return {
  {
    "nvim-neorg/neorg",
    lazy = true,
    ft = "norg",
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
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
      { "pysan3/neorg-templates", dependencies = { "l3mon4d3/luasnip" } },
      { "pritchett/neorg-capture" },
      -- this adds a keymap "<enter>" that fails when not in a neorg file
      { "benlubas/neorg-conceal-wrap" },
      { "benlubas/neorg-interim-ls" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.completion"] = {
            config = {
              engine = {
                module_name = "external.lsp-completion",
              },
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

          -- external plugins
          ["external.conceal-wrap"] = {},
          ["external.templates"] = {
            templates_dir = vim.fn.stdpath("config") .. "/templates/norg",
            default_subcommand = "load",
          },
          ["external.interim-ls"] = {
            config = {
              -- default config shown
              completion_provider = {
                -- Enable or disable the completion provider
                enable = true,

                -- Show file contents as documentation when you complete a file name
                documentation = true,

                -- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
                categories = false,
              },
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
          end

          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          -- ... your other lsp mappings
        end,
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
