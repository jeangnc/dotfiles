local M = {}
local common = require("utils.common")

-- Cache for discovered commands
local _cached_commands = nil

--- Discover all Claude slash commands from plugin directories
function M.discover_commands()
  local commands = {}

  local search_patterns = {
    "~/.claude/plugins/marketplaces/gq-marketplace/*/commands",
    "~/.claude/plugins/marketplaces/jeangnc-marketplace/plugins/*/commands",
    "~/.claude/commands",
  }

  for _, pattern in ipairs(search_patterns) do
    -- glob() handles both ~ expansion and glob patterns correctly
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
---@return table Context with file_path and optional line range
function M.get_context(mode)
  mode = mode or vim.fn.mode()

  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Check if in visual mode (v=visual, V=visual line, \22=Ctrl-V visual block)
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Get visual selection line range (0-indexed for claudecode API)
    local start_line = vim.fn.line("'<") - 1
    local end_line = vim.fn.line("'>") - 1
    return {
      file_path = filepath,
      start_line = start_line,
      end_line = end_line,
    }
  end

  -- Otherwise return current buffer path
  if filepath and filepath ~= "" then
    return { file_path = filepath }
  end

  return {}
end

--- Execute a Claude command in the interactive Claude terminal
---@param command table Command specification
---@param args string|nil Optional arguments
---@param context table|nil Optional context with file_path and line range
function M.execute_in_claude(command, args, context)
  local terminal = require("claudecode.terminal")

  -- Ensure terminal is open
  terminal.open()

  -- Build input text: command @file (for no-arg commands) or command args
  local input_parts = {}

  -- Add command first
  table.insert(input_parts, command.full_name)

  -- Add args if present, otherwise add @mention for file context
  if args and args ~= "" then
    table.insert(input_parts, args)
  elseif context and context.file_path and context.file_path ~= "" then
    table.insert(input_parts, "@" .. context.file_path)
  end

  local input_text = table.concat(input_parts, " ")

  -- Wait for terminal buffer, then type command (user presses Enter when ready)
  vim.defer_fn(function()
    local bufnr = terminal.get_active_terminal_bufnr()
    if bufnr then
      -- Focus terminal window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
      -- Enter terminal insert mode and type command
      vim.cmd("startinsert")
      vim.schedule(function()
        vim.api.nvim_feedkeys(input_text, "t", true)
      end)
    else
      vim.notify("Could not find Claude terminal", vim.log.levels.ERROR)
    end
  end, 200)
end

--- Handle command selection and execution
---@param command table The selected command
---@param context table|nil Pre-captured context (file_path, start_line, end_line)
function M.handle_command_selection(command, context)
  -- Use provided context or capture current (fallback for direct calls)
  if not context then
    local mode = vim.fn.mode()
    context = M.get_context(mode)
  end

  if command.needs_input then
    -- Prompt for input argument
    local input_prompt = string.format("%s (e.g., PR URL, ticket ID): ", command.name)
    vim.ui.input({ prompt = input_prompt }, function(input)
      if input and input:match("%S") then
        M.execute_in_claude(command, input, context)
      end
    end)
  else
    M.execute_in_claude(command, nil, context)
  end
end

--- Show command picker using FZF
function M.show_command_picker()
  local commands = M.get_commands()

  if #commands == 0 then
    vim.notify("No Claude commands found", vim.log.levels.WARN)
    return
  end

  -- Capture context BEFORE opening picker (current buffer will change during FZF)
  local mode = vim.fn.mode()
  local context = M.get_context(mode)

  -- Format commands for display: [plugin-name] Description
  local items = {}
  for _, cmd in ipairs(commands) do
    local display = string.format("[%s] %s", cmd.plugin, cmd.description)
    table.insert(items, display)
  end

  -- Use FZF to select
  common.fzf_select(items, "Claude Commands> ", function(selected)
    if not selected then
      return
    end

    -- Find the corresponding command
    local idx
    for i, item in ipairs(items) do
      if item == selected then
        idx = i
        break
      end
    end

    if idx then
      M.handle_command_selection(commands[idx], context)
    end
  end, {
    empty_message = "No commands found",
  })
end

return M
