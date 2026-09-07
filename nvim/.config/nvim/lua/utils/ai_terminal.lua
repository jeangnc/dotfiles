local agent = require("config.ai_agent")

local terminals = {
  claude = "claudecode.terminal",
  codex = "codex.terminal",
}

local M = {}

function M.active()
  return require(terminals[agent.name])
end

return M
