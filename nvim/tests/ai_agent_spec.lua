local function load_agent(value)
  vim.g.ai_agent = value
  package.loaded["config.ai_agent"] = nil
  return require("config.ai_agent")
end

assert(load_agent("claude").name == "claude")
assert(load_agent("codex").name == "codex")

local ok, err = pcall(load_agent, "other")
assert(not ok)
assert(err:match("Invalid AI agent"))
