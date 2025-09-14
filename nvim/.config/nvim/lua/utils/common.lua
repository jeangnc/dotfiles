local M = {}

-- ============================================================================
-- Command Execution Utilities
-- ============================================================================

function M.execute_sync_command(command)
  if vim.fn.system(command) and vim.v.shell_error ~= 0 then
    return false, "Command failed: " .. command
  end
  return true
end

function M.execute_async_command(cmd_args, opts, callback)
  opts = opts or {}
  vim.system(cmd_args, opts, callback)
end

function M.execute_popen_command(command)
  local handle = io.popen(command)
  if not handle then
    return nil, "Failed to execute command: " .. command
  end

  local result = handle:read("*a")
  local success = handle:close()

  if not success then
    return nil, "Command execution failed: " .. command
  end

  return result
end

-- ============================================================================
-- Options Handling
-- ============================================================================

function M.merge_opts(default_opts, user_opts)
  user_opts = user_opts or {}
  return vim.tbl_extend("force", default_opts, user_opts)
end

function M.get_opt(opts, key, default_value)
  opts = opts or {}
  return opts[key] or default_value
end

-- ============================================================================
-- Error Handling & Notifications
-- ============================================================================

function M.handle_result(success, error_message)
  if not success then
    vim.notify(error_message, vim.log.levels.ERROR)
    return false
  end
  return true
end

-- ============================================================================
-- String Processing Utilities
-- ============================================================================

function M.split_lines(text)
  local lines = {}
  for line in text:gmatch("[^\r\n]+") do
    if line ~= "" then
      table.insert(lines, line)
    end
  end
  return lines
end

function M.is_empty_list(list)
  return not list or #list == 0
end

-- ============================================================================
-- FZF Integration Utilities
-- ============================================================================

function M.create_fzf_action(callback)
  return {
    ["default"] = function(selected)
      if M.is_empty_list(selected) then
        return
      end
      callback(selected[1], selected)
    end
  }
end

function M.fzf_select(items, prompt, callback, opts)
  opts = opts or {}
  local fzf = require("fzf-lua")

  if M.is_empty_list(items) then
    if opts.empty_message then
      vim.notify(opts.empty_message, vim.log.levels.WARN)
    end
    if opts.fallback_fn then
      opts.fallback_fn()
    end
    return
  end

  fzf.fzf_exec(items, {
    prompt = prompt,
    actions = M.create_fzf_action(callback)
  })
end

function M.fzf_input(prompt, callback)
  vim.ui.input({ prompt = prompt }, function(input)
    if not input or input == "" then
      return
    end
    callback(input)
  end)
end


-- ============================================================================
-- Validation Utilities
-- ============================================================================

function M.validate_path(path, action_name)
  if not path then
    vim.notify("No " .. (action_name or "path") .. " provided", vim.log.levels.ERROR)
    return false
  end
  return true
end

return M