local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

local function navigate_command(key)
  return "TmuxNavigate" .. directions[key]
end

local function terminal_navigation(key)
  return function(terminal)
    if terminal:is_floating() then
      return "<c-" .. key .. ">"
    end
    vim.schedule(function()
      vim.cmd(navigate_command(key))
    end)
  end
end

local function terminal_key(key)
  return {
    "<C-" .. key .. ">",
    terminal_navigation(key),
    desc = "Go to " .. directions[key] .. " Window",
    expr = true,
    mode = "t",
  }
end

local function normal_key(key)
  return { "<c-" .. key .. ">", "<cmd><C-U>" .. navigate_command(key) .. "<cr>" }
end

return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      normal_key("h"),
      normal_key("j"),
      normal_key("k"),
      normal_key("l"),
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          keys = {
            nav_h = terminal_key("h"),
            nav_j = terminal_key("j"),
            nav_k = terminal_key("k"),
            nav_l = terminal_key("l"),
          },
        },
      },
    },
  },
}
