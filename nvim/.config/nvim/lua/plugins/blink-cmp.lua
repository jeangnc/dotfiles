return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = {
          score_offset = -5,
        },
      },
    },
    keymap = {
      ["<Cr>"] = {},
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },

      ["<C-l>"] = { "select_and_accept", "fallback" },
      ["<C-h>"] = { "hide", "fallback" },

      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },

      ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      ["<C-u>"] = { "scroll_documentation_down", "fallback" },

      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },
  },

  init = function()
    -- Custom keymap for snippets-only completion
    vim.keymap.set({ "n", "i" }, "<C-p>", function()
      if vim.fn.mode() == "n" then
        vim.cmd("startinsert")
      end
      require("blink.cmp").show({ sources = { "snippets" } })
    end, { desc = "Show snippets" })
  end,
}
