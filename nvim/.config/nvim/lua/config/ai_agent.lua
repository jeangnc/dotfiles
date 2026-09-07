local name = vim.g.ai_agent

if name ~= "claude" and name ~= "codex" then
  error("Invalid AI agent: " .. vim.inspect(name) .. ". Expected 'claude' or 'codex'.")
end

vim.g.ai_agent = name

return { name = name }
