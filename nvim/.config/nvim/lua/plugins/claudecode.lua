local split_pct = 0.40
local window = require("utils.window")

return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeSendText",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    config = true,
    init = function()
      window.keep_width_pct({
        name = "claudecode_resize",
        pct = split_pct,
        window = function()
          local terminal = package.loaded["claudecode.terminal"]
          return terminal and window.find_by_buf(terminal.get_active_terminal_bufnr())
        end,
      })
    end,
    opts = {
      -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = "claude --dangerously-skip-permissions",
      -- For local installations: "~/.claude/local/claude"
      -- For native binary: use output from 'which claude'
      track_selection = true,

      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = split_pct,
        provider = "auto", -- "auto", "snacks", "native", "external", or custom provider table
        auto_close = true,
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below

        -- Provider-specific options
        provider_opts = {
          external_terminal_cmd = nil, -- Command template for external terminal provider (e.g., "alacritty -e %s")
        },
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = false,
        keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
      },
    },
  },
}
