local split_pct = 0.40
local window = require("utils.window")

return {
  "ishiooon/codex.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = {
    "Codex",
    "CodexFocus",
    "CodexMaximizeToggle",
    "CodexSelectModel",
    "CodexAdd",
    "CodexSend",
    "CodexTreeAdd",
    "CodexStatus",
    "CodexStart",
    "CodexStop",
    "CodexOpen",
    "CodexClose",
    "CodexDiffAccept",
    "CodexDiffDeny",
  },
  init = function()
    window.keep_width_pct({
      name = "codex_resize",
      pct = split_pct,
      window = function()
        local terminal = package.loaded["codex.terminal"]
        return terminal and window.find_by_buf(terminal.get_active_terminal_bufnr())
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
}
