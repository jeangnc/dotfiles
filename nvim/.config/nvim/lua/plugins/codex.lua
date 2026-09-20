local agent = require("config.ai_agent")

local split_pct = 0.40
local window = require("utils.window")

return {
  "ishiooon/codex.nvim",
  enabled = agent.name == "codex",
  dependencies = {
    "folke/snacks.nvim",
  },
  init = function()
    window.keep_width_pct({
      name = "codex_resize",
      pct = split_pct,
      window = function()
        return window.find_by_buf(require("codex.terminal").get_active_terminal_bufnr())
      end,
    })
  end,
  opts = {
    terminal_cmd = "codex",
    track_selection = true,
    visual_demotion_delay_ms = 50,
    keymaps = false,
    status_indicator = {
      enabled = false,
    },
    terminal = {
      split_side = "right",
      split_width_percentage = split_pct,
      provider = "auto",
      auto_close = true,
      snacks_win_opts = {},
      provider_opts = {
        external_terminal_cmd = nil,
      },
    },
    diff_opts = {
      layout = "vertical",
      open_in_new_tab = false,
      keep_terminal_focus = true,
    },
  },
  keys = {
    { "<leader>ac", "<cmd>Codex<cr>", desc = "Codex" },
    { "<leader>af", "<cmd>CodexFocus<cr>", desc = "Focus Codex" },
    { "<leader>am", "<cmd>CodexSelectModel<cr>", desc = "Select Codex model" },
    { "<leader>ab", "<cmd>CodexAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>CodexSend<cr>", desc = "Send to Codex", mode = "v" },
    {
      "<leader>as",
      "<cmd>CodexTreeAdd<cr>",
      desc = "Add file",
      ft = { "neo-tree", "oil" },
    },
    { "<leader>aa", "<cmd>CodexDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>CodexDiffDeny<cr>", desc = "Deny diff" },
  },
}
