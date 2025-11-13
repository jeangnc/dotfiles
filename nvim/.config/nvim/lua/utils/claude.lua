local M = {}
local common = require("utils.common")

-- Cache for discovered commands
local _cached_commands = nil

--- Discover all Claude slash commands from plugin directories
function M.discover_commands()
  local commands = {}

  local search_dirs = {
    vim.fn.expand("~/.claude/plugins/marketplaces/gq-marketplace/*/commands"),
    vim.fn.expand("~/.claude/plugins/marketplaces/jeangnc-marketplace/plugins/*/commands"),
    vim.fn.expand("~/.claude/commands"),
  }

  for _, pattern in ipairs(search_dirs) do
    local dirs = vim.fn.glob(pattern, false, true)
    for _, dir in ipairs(dirs) do
      local files = vim.fn.glob(dir .. "/*.md", false, true)
      for _, file in ipairs(files) do
        local cmd = M.parse_command_file(file)
        if cmd then
          table.insert(commands, cmd)
        end
      end
    end
  end

  return commands
end

--- Parse a command markdown file to extract metadata
---@param filepath string Path to the .md command file
---@return table|nil Command metadata or nil if parsing failed
function M.parse_command_file(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()

  -- Extract plugin name and command name from path
  -- Example: ~/.claude/plugins/marketplaces/gq-marketplace/gq-dev/commands/review-pr.md
  local plugin_name = filepath:match("/([^/]+)/commands/[^/]+%.md$")
  local cmd_name = filepath:match("/([^/]+)%.md$")

  if not plugin_name or not cmd_name then
    return nil
  end

  -- Build full command name
  local full_name = string.format("/%s:%s", plugin_name, cmd_name)

  -- Extract description from YAML frontmatter
  local description = content:match("^%-%-%-%s*\n.-description:%s*([^\n]+)") or cmd_name
  description = description:gsub("^['\"]", ""):gsub("['\"]$", "") -- Remove quotes

  -- Detect if command needs arguments by looking for $1, $2, etc
  local needs_input = content:match("%$%d+") ~= nil

  -- Infer category from plugin name
  local category = "General"
  if plugin_name:match("gq%-dev") or plugin_name:match("dev%-tools") then
    if cmd_name:match("review") or cmd_name:match("migration") then
      category = "Code Review"
    elseif cmd_name:match("plan") then
      category = "Planning"
    elseif cmd_name:match("issue") or cmd_name:match("pr") then
      category = "Tickets"
    end
  elseif plugin_name:match("finance") then
    category = "Utilities"
  end

  return {
    name = cmd_name,
    full_name = full_name,
    description = description,
    needs_input = needs_input,
    category = category,
    plugin = plugin_name,
  }
end

--- Get all commands (with caching)
function M.get_commands()
  if not _cached_commands then
    _cached_commands = M.discover_commands()
  end
  return _cached_commands
end

--- Force refresh the command cache
function M.refresh_commands()
  _cached_commands = nil
  return M.get_commands()
end

--- Get context from current buffer or visual selection
---@param mode string|nil Optional mode hint
---@return string|nil Context text or file path
function M.get_context(mode)
  mode = mode or vim.fn.mode()

  -- Check if in visual mode
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Get visual selection
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg("v")
    return text
  end

  -- Otherwise return current buffer path
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if filepath and filepath ~= "" then
    return filepath
  end

  return nil
end

--- Execute a Claude command
---@param command table Command specification
---@param args string|nil Optional arguments
---@param context string|nil Optional context (selection or file)
function M.execute_command(command, args, context)
  local cmd_parts = { "claude", "-p" }

  -- Build command with arguments
  local full_cmd = command.full_name
  if args and args ~= "" then
    full_cmd = full_cmd .. " " .. args
  end

  -- Wrap in quotes to handle spaces
  table.insert(cmd_parts, "'" .. full_cmd .. "'")

  -- Add context if provided (pipe file content)
  local cmd_str
  if context and vim.fn.filereadable(context) == 1 then
    -- It's a file path, pipe its content
    cmd_str = string.format("cat '%s' | %s", context, table.concat(cmd_parts, " "))
  else
    -- Just the command
    cmd_str = table.concat(cmd_parts, " ")
  end

  -- Show notification that command is running
  vim.notify(string.format("Running: %s", command.name), vim.log.levels.INFO)

  -- Execute command asynchronously
  vim.fn.jobstart(cmd_str, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        local output = table.concat(data, "\n")
        if output and output ~= "" then
          M.show_result(output, command.name)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        local err = table.concat(data, "\n")
        if err and err ~= "" then
          vim.notify(string.format("Error: %s", err), vim.log.levels.ERROR)
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify(string.format("Command failed with exit code: %d", exit_code), vim.log.levels.ERROR)
      end
    end,
  })
end

--- Show command result in a scratch buffer
---@param content string The content to display
---@param title string Title for the buffer
function M.show_result(content, title)
  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Split content into lines
  local lines = vim.split(content, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Open in a new window
  vim.cmd("botright vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_name(buf, "Claude: " .. title)

  -- Set local keymaps to close easily
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
end

--- Handle command selection and execution
---@param command table The selected command
function M.handle_command_selection(command)
  local mode = vim.fn.mode()

  if command.needs_input then
    -- Prompt for input
    local input_prompt = string.format("%s (e.g., PR URL, ticket ID): ", command.name)
    vim.ui.input({ prompt = input_prompt }, function(input)
      if input and input ~= "" then
        M.execute_command(command, input, nil)
      end
    end)
  else
    -- Use context from buffer or selection
    local context = M.get_context(mode)
    M.execute_command(command, nil, context)
  end
end

--- Show command picker using FZF
function M.show_command_picker()
  local commands = M.get_commands()

  if #commands == 0 then
    vim.notify("No Claude commands found", vim.log.levels.WARN)
    return
  end

  -- Format commands for display: [Category] Description (plugin:command)
  local items = {}
  for _, cmd in ipairs(commands) do
    local display = string.format("[%s] %s (%s)", cmd.category, cmd.description, cmd.full_name)
    table.insert(items, display)
  end

  -- Use FZF to select
  common.fzf_select(items, "Claude Commands> ", function(selected)
    if not selected then
      return
    end

    -- Find the corresponding command
    local idx = nil
    for i, item in ipairs(items) do
      if item == selected then
        idx = i
        break
      end
    end

    if idx then
      M.handle_command_selection(commands[idx])
    end
  end, {
    empty_message = "No commands found",
  })
end

return M
