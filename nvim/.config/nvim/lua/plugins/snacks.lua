return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
  },
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    indent = {
      enabled = true,
      filter = function(buf)
        return vim.bo[buf].filetype ~= "norg"
      end,
    },
    scope = { enabled = true },

    notifier = {
      enabled = true,
      top_down = false,
      timeout = 3000,
    },

    ---@type table<string, snacks.win.Config>
    styles = {
      notification = {
        wo = { wrap = true },
      },
      scratch = {
        width = 200,
        height = 30,
      },
      zen = {
        enter = true,
        fixbuf = false,
        minimal = true,
        width = 120,
        height = 0,
        backdrop = { transparent = false, blend = 40 },
        keys = { q = false },
        zindex = 40,
        wo = {
          winhighlight = "NormalFloat:Normal",
        },
        w = {
          snacks_main = true,
        },
      },
    },

    terminal = {
      win = {
        position = "float",
      },
    },

    ---@class snacks.scratch.Config
    ---@field win? snacks.win.Config scratch window
    ---@field template? string template for new buffers
    ---@field file? string scratch file path. You probably don't need to set this.
    ---@field ft? string|fun():string the filetype of the scratch buffer
    scratch = {},
  },
}
