local M = {}

-- ============================================================================
-- Private Helper Functions
-- ============================================================================

local file = require("utils.file")
local dir = require("utils.dir")
local templates = require("utils.templates")

local function validate_workspace()
  local workspace_dir = M.current_workspace_dir()
  if not workspace_dir then
    vim.notify("No active neorg workspace", vim.log.levels.ERROR)
    return nil
  end
  return workspace_dir
end

local function get_neorg_opts()
  return { extension = "norg" }
end

-- ============================================================================
-- Workspace Management
-- ============================================================================

function M.current_workspace_dir()
  local dirman = require("neorg").modules.get_module("core.dirman")
  local current_workspace = dirman.get_current_workspace()

  if current_workspace then
    return tostring(current_workspace[2])
  end
end

function M.is_file_in_workspace(file_path)
  local workspace_dir = M.current_workspace_dir()
  if not workspace_dir then
    return false
  end
  return file_path:find(workspace_dir, 1, true) == 1
end

function M.get_default_workspace()
  local config_path = file.find_in_parents(".neorg/config.json")

  if config_path then
    local config = file.load_json(config_path)
    if config and config.default_workspace then
      return config.default_workspace
    end
  end

  return "personal"
end

-- ============================================================================
-- Neorg-specific UI Functions
-- ============================================================================

function M.search_files_in_directory(directory_path)
  return dir.search_files(directory_path, {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f --extension=norg",
  })
end

function M.search_content_in_directory(directory_path)
  return dir.search_content(directory_path, {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
  })
end

-- ============================================================================
-- Note Creation
-- ============================================================================

function M.create_note_with_template()
  local workspace_directory = validate_workspace()
  if not workspace_directory then
    return false
  end

  local templates_directory = vim.fn.expand("~/.orgfiles/templates/")
  local destination_directory = workspace_directory .. "/inbox"

  return templates.select_template_and_create_file(templates_directory, destination_directory, vim.tbl_extend("force", get_neorg_opts(), {
    fallback_fn = function()
      M.create_blank_note()
    end,
  }))
end

function M.create_blank_note(filename)
  local workspace_directory = validate_workspace()
  if not workspace_directory then
    return false
  end

  local destination_directory = workspace_directory .. "/inbox"
  return templates.create_file_from_template(filename or "new-note", nil, destination_directory, get_neorg_opts())
end


-- ============================================================================
-- Convenience Functions (Workspace Shortcuts)
-- ============================================================================

local function with_workspace_dir(callback)
  local workspace_dir = validate_workspace()
  if not workspace_dir then
    return false
  end
  callback(workspace_dir)
  return true
end

function M.explore_workspace()
  return with_workspace_dir(dir.open_explorer)
end

function M.search_files()
  return with_workspace_dir(M.search_files_in_directory)
end

function M.search_content()
  return with_workspace_dir(M.search_content_in_directory)
end

function M.explore_journal()
  return with_workspace_dir(function(workspace_dir)
    dir.open_explorer(workspace_dir .. "/.journalfiles")
  end)
end

-- ============================================================================
-- Journal Continuation
-- ============================================================================

local function scan_journal_files(journal_dir)
  local files = {}
  local scan = vim.loop.fs_scandir(journal_dir)

  if not scan then
    return files
  end

  while true do
    local name, type = vim.loop.fs_scandir_next(scan)
    if not name then break end

    if type == "directory" then
      -- Recursively scan subdirectories (year/month structure)
      local subdir = journal_dir .. "/" .. name
      local subfiles = scan_journal_files(subdir)
      for _, f in ipairs(subfiles) do
        table.insert(files, f)
      end
    elseif type == "file" and name:match("%.norg$") then
      table.insert(files, journal_dir .. "/" .. name)
    end
  end

  return files
end

local function parse_journal_date(filepath)
  -- Extract date from nested structure: .journalfiles/YYYY/MM/DD.norg
  local pattern = "/(%d%d%d%d)/(%d%d)/(%d%d)%.norg$"
  local year, month, day = filepath:match(pattern)

  if year and month and day then
    return os.time({
      year = tonumber(year),
      month = tonumber(month),
      day = tonumber(day),
      hour = 0,
      min = 0,
      sec = 0
    })
  end

  return nil
end

local function find_most_recent_journal(workspace_dir)
  local journal_dir = workspace_dir .. "/.journalfiles"

  -- Check if journal directory exists
  local stat = vim.loop.fs_stat(journal_dir)
  if not stat or stat.type ~= "directory" then
    return nil
  end

  local files = scan_journal_files(journal_dir)

  -- Normalize today to midnight to correctly exclude today's journal
  local now = os.date("*t")
  local today = os.time({
    year = now.year,
    month = now.month,
    day = now.day,
    hour = 0,
    min = 0,
    sec = 0
  })

  local most_recent = nil
  local most_recent_time = 0

  for _, filepath in ipairs(files) do
    local file_time = parse_journal_date(filepath)
    if file_time and file_time < today and file_time > most_recent_time then
      most_recent = filepath
      most_recent_time = file_time
    end
  end

  return most_recent
end

-- Recursively check if a node contains completed/cancelled todos
local function contains_completed_todo(node)
  local node_type = node:type()

  -- Check if this node itself is a completed/cancelled todo
  if node_type == "todo_item_done" or node_type == "todo_item_cancelled" then
    return true
  end

  -- Recursively check children
  for child in node:iter_children() do
    if contains_completed_todo(child) then
      return true
    end
  end

  return false
end

local function should_keep_node(node, bufnr)
  local node_type = node:type()

  -- For list items, check if they contain completed/cancelled todos
  if node_type == "unordered_list1" or node_type == "unordered_list2" or node_type == "unordered_list3" then
    if contains_completed_todo(node) then
      return false
    end
    return true
  end

  -- Remove paragraphs that are just timestamps (HH:MM format)
  if node_type == "paragraph" or node_type == "paragraph_segment" then
    local text = vim.treesitter.get_node_text(node, bufnr)
    -- Check if it's ONLY a timestamp (with optional whitespace)
    if text and text:match("^%s*%d%d:%d%d%s*$") then
      return false
    end
    return true
  end

  -- Keep everything else (headings, quotes, regular content, horizontal lines)
  return true
end

-- Remove consecutive empty lines from a list of lines
local function remove_consecutive_empty_lines(lines)
  local result = {}
  local prev_empty = false
  for _, line in ipairs(lines) do
    local is_empty = line:match("^%s*$")
    if not (is_empty and prev_empty) then
      table.insert(result, line)
    end
    prev_empty = is_empty
  end
  return result
end

local function filter_journal_content(filepath)
  -- Load file into a temporary buffer
  local bufnr = vim.fn.bufadd(filepath)
  vim.fn.bufload(bufnr)

  -- Parse with treesitter
  local parser = vim.treesitter.get_parser(bufnr, "norg")
  local tree = parser:parse()[1]
  local root = tree:root()

  local filtered_lines = {}
  local lines_to_skip = {}
  local lines_to_uncheck = {}  -- Lines containing routine todos to uncheck

  -- Track if we're under heading1 (routine section) or heading2+ (regular section)
  local under_heading1 = false
  local under_heading2_plus = false

  -- First pass: identify lines to skip and lines to uncheck
  local function mark_lines_to_skip(node, parent)
    local node_type = node:type()

    -- Track heading context
    if node_type == "heading1" then
      under_heading1 = true
      under_heading2_plus = false
    elseif node_type:match("^heading[2-9]") then
      under_heading1 = false
      under_heading2_plus = true
    end

    -- Check routine todos FIRST (before should_keep_node)
    if (node_type == "unordered_list1" or node_type == "unordered_list2" or node_type == "unordered_list3")
       and under_heading1 and not under_heading2_plus then
      if contains_completed_todo(node) then
        -- Routine todo: mark for unchecking instead of skipping
        local start_row, _, end_row, end_col = node:range()
        local actual_end_row = (end_col == 0) and (end_row - 1) or end_row
        for i = start_row, actual_end_row do
          lines_to_uncheck[i] = true
        end
        return  -- Don't process further
      end
    end

    if not should_keep_node(node, bufnr) then
      local start_row, _, end_row, end_col = node:range()
      local actual_end_row = (end_col == 0) and (end_row - 1) or end_row
      for i = start_row, actual_end_row do
        lines_to_skip[i] = true
      end
    else
      -- Check if this is a list following a timestamp paragraph
      if node_type == "generic_list" and parent then
        local prev_sibling = nil
        for child in parent:iter_children() do
          if child == node then
            break
          end
          if child:type() == "paragraph" then
            prev_sibling = child
          end
        end

        if prev_sibling then
          local prev_text = vim.treesitter.get_node_text(prev_sibling, bufnr)
          if prev_text and prev_text:match("^%s*%d%d:%d%d%s*$") then
            local start_row, _, end_row, end_col = node:range()
            local actual_end_row = (end_col == 0) and (end_row - 1) or end_row
            for i = start_row, actual_end_row do
              lines_to_skip[i] = true
            end
            return
          end
        end
      end

      -- Recursively check children
      for child in node:iter_children() do
        mark_lines_to_skip(child, node)
      end
    end
  end

  for node in root:iter_children() do
    mark_lines_to_skip(node, root)
  end

  -- Second pass: collect and process lines
  local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(all_lines) do
    local line_idx = i - 1  -- 0-indexed
    if not lines_to_skip[line_idx] then
      if lines_to_uncheck[line_idx] then
        -- Uncheck the todo: (x) or (-) → ( )
        line = line:gsub("%-(%s*)%([xX%-]%)", "-%1( )")
      end
      table.insert(filtered_lines, line)
    end
  end

  -- Clean up temporary buffer
  vim.api.nvim_buf_delete(bufnr, { force = true })

  return remove_consecutive_empty_lines(filtered_lines)
end

function M.continue_journal()
  -- Validate we're in a workspace
  local workspace_dir = validate_workspace()
  if not workspace_dir then
    return
  end

  -- Find most recent journal entry
  local previous_journal = find_most_recent_journal(workspace_dir)

  if not previous_journal then
    vim.notify("No previous journal entries found", vim.log.levels.WARN)
    return
  end

  -- Filter content from previous journal
  local ok, filtered_content = pcall(filter_journal_content, previous_journal)

  if not ok then
    vim.notify("Failed to filter journal content: " .. tostring(filtered_content), vim.log.levels.ERROR)
    return
  end

  if #filtered_content == 0 then
    vim.notify("No content to continue from previous journal", vim.log.levels.INFO)
    return
  end

  -- Replace current buffer content
  local current_bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(current_bufnr, 0, -1, false, filtered_content)

  -- Extract date from filepath for notification
  local date_match = previous_journal:match("(%d%d%d%d/%d%d/%d%d)%.norg$")
  vim.notify("Continued from journal: " .. (date_match or previous_journal), vim.log.levels.INFO)
end

return M

