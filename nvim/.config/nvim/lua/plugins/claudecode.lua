return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
      -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = "claude /code", -- Custom terminal command (default: "claude")
      -- For local installations: "~/.claude/local/claude"
      -- For native binary: use output from 'which claude'

      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.40,
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
        open_in_current_tab = true,
        keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>a", group = "AI", icon = "🤖" },
      },
    },
  },
}
