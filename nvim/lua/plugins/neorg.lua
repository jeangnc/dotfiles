-- required to compile the norg treesitter parser
require("nvim-treesitter.install").compilers = { "gcc-14" }

local function current_workspace_dir()
  local dirman = require("neorg").modules.get_module("core.dirman")
  local current_workspace = dirman.get_current_workspace()

  if current_workspace then
    return tostring(current_workspace[2])
  end
end

local function neotree_explore(folder)
  if not folder then
    return
  end

  local expanded_path = vim.fn.expand(folder)

  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "left",
    dir = expanded_path,
  })
end

local function fzf_grep(folder)
  if not folder then
    return
  end

  local opts = {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
    cwd = folder,
  }

  require("fzf-lua").live_grep(opts)
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
          neotree_explore(current_workspace_dir())
        end,
        desc = "Explore Neorg files (workspace)",
      },
      { "<leader>o<space>", "<cmd>Neorg fzf files<cr>", desc = "Search Neorg files (workspace)" },
      {
        "<leader>o0",
        function()
          fzf_grep(current_workspace_dir())
        end,
        desc = "Live grep Neorg files (workspace)",
      },
      { "<leader>oi", "<cmd>Neorg index<cr>", desc = "Opens workspace's index file" },
      { "<leader>or", "<cmd>Neorg return<cr>", desc = "Closes all Neorg-related buffers" },
      { "<leader>on", "<Plug>(neorg.dirman.new-note)", desc = "Creates a new norg file" },
      {
        "<leader>oje",
        function()
          neotree_explore(current_workspace_dir() .. "/**/.journalfiles")
        end,
        desc = "Explore journal files (workspace)",
      },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojp", "<cmd>Neorg journal yesterday<cr>", desc = "Open previous day's journal" },
      { "<leader>ojc", "<cmd>Neorg journal today<cr>", desc = "Open current today's journal" },
      { "<leader>ojn", "<cmd>Neorg journal tomorrow<cr>", desc = "Open next day's journal" },
    },
    dependencies = {
      { "benlubas/neorg-conceal-wrap" },
      { "benlubas/neorg-interim-ls" },
      { "bottd/neorg-archive" },
      { "kev-cao/neorg-fzflua" },
      { "max397574/neorg-contexts" },
      { "phenax/neorg-hop-extras" },

      -- required by most plugins
      { "nvim-lua/plenary.nvim" },
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
                archive = "~/.orgfiles/archive",
              },
              default_workspace = "work",
            },
          },
          ["core.journal"] = {
            config = {
              journal_folder = ".journalfiles",
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

                -- suggest heading completions from the given file for `{@x|}` where `|` is your cursor
                -- and `x` is an alphanumeric character. `{@name}` expands to `[name]{:$/people:# name}`
                people = {
                  enable = false,

                  -- path to the file you're like to use with the `{@x` syntax, relative to the
                  -- workspace root, without the `.norg` at the end.
                  -- ie. `folder/people` results in searching `$/folder/people.norg` for headings.
                  -- Note that this will change with your workspace, so it fails silently if the file
                  -- doesn't exist
                  path = "people",
                },
              },
            },
          },

          ["external.archive"] = {
            -- default config
            config = {
              -- (Optional) Archive workspace name, defaults to "archive"
              workspace = "archive",
              -- (Optional) Enable/disable confirming archive operations
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
          ["external.integrations.fzf-lua"] = {},
        },
      })

      -- interim-ls
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

      -- ft specific settings
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "norg",
        callback = function()
          vim.opt_local.textwidth = 100
          vim.opt_local.colorcolumn = "100"

          vim.keymap.set("n", "gl", "<plug>(neorg.external.hop-extras.hop-link)")
          vim.keymap.set({ "n", "v", "o" }, "<C-E>", "<cmd>Neorg toc<cr>", { desc = "Toggle ToC", buffer = true })

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
