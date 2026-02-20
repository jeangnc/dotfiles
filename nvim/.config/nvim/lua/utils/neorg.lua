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

  return templates.select_template_and_create_file(
    templates_directory,
    destination_directory,
    vim.tbl_extend("force", get_neorg_opts(), {
      fallback_fn = function()
        M.create_blank_note()
      end,
    })
  )
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
    if not name then
      break
    end

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
      sec = 0,
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
    sec = 0,
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

-- Check if a list item has undone status (should be carried over)
-- Returns true only for todo_item_undone
-- Returns false for done/cancelled/pending
-- Returns nil if no todo marker found yet (continue searching)
local function is_pending_todo(node)
  local node_type = node:type()

  -- Found undone todo - keep it
  if node_type == "todo_item_undone" then
    return true
  end

  -- Found done, cancelled, or pending todo - filter it
  if node_type == "todo_item_done" or node_type == "todo_item_cancelled" or node_type == "todo_item_pending" then
    return false
  end

  -- Check children, but skip nested list items (they're evaluated separately)
  for child in node:iter_children() do
    local child_type = child:type()
    if not child_type:match("^unordered_list%d$") then
      local result = is_pending_todo(child)
      if result ~= nil then
        return result
      end
    end
  end

  return nil
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

-- Extract undone ( ) todos from a journal file, grouped by heading3 subsection key
local function extract_undone_todos(filepath)
  local bufnr = vim.fn.bufadd(filepath)
  vim.fn.bufload(bufnr)

  local parser = vim.treesitter.get_parser(bufnr, "norg")
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Map from subsection key (e.g. "Crucial") to list of item line groups
  local todos_by_subsection = {}
  local in_todo_section = false
  local current_subsection = nil

  local function walk(node)
    local node_type = node:type()

    -- Track heading sections
    if node_type:match("^heading%d$") then
      local level = tonumber(node_type:match("(%d)$"))
      local start_row = node:range()
      local title = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ""

      if level == 2 then
        if title:lower():match("to%s*do") then
          in_todo_section = true
        else
          in_todo_section = false
          current_subsection = nil
        end
      elseif level == 3 and in_todo_section then
        local key = title:match("%*%*%*%s*(%w+)")
        if key then
          current_subsection = key
          todos_by_subsection[key] = todos_by_subsection[key] or {}
        end
      end
    end

    -- Collect undone todo items in the TO DO section
    if in_todo_section and current_subsection and node_type:match("^unordered_list%d$") then
      if is_pending_todo(node) then
        local start_row, _, end_row, end_col = node:range()
        local actual_end_row = (end_col == 0) and (end_row - 1) or end_row
        local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, actual_end_row + 1, false)
        table.insert(todos_by_subsection[current_subsection], lines)
      end
      return -- Don't recurse into list items
    end

    for child in node:iter_children() do
      walk(child)
    end
  end

  for node in root:iter_children() do
    walk(node)
  end

  vim.api.nvim_buf_delete(bufnr, { force = true })
  return todos_by_subsection
end

-- Fallback: copy previous journal directly, keeping only undone ( ) todos
-- and resetting routine items outside TO DO back to ( )
local function filter_previous_journal(filepath)
  local bufnr = vim.fn.bufadd(filepath)
  vim.fn.bufload(bufnr)

  local parser = vim.treesitter.get_parser(bufnr, "norg")
  local tree = parser:parse()[1]
  local root = tree:root()

  local lines_to_skip = {}
  local lines_to_uncheck = {}
  local in_todo_section = false

  local function walk(node)
    local node_type = node:type()

    if node_type:match("^heading%d$") then
      local level = tonumber(node_type:match("(%d)$"))
      if level == 2 then
        local start_row = node:range()
        local title = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ""
        in_todo_section = title:lower():match("to%s*do") ~= nil
      end
    end

    if node_type:match("^unordered_list%d$") then
      local is_undone = is_pending_todo(node)
      local start_row, _, end_row, end_col = node:range()
      local actual_end_row = (end_col == 0) and (end_row - 1) or end_row

      if in_todo_section then
        -- Remove completed/cancelled/pending items
        if not is_undone then
          for i = start_row, actual_end_row do
            lines_to_skip[i] = true
          end
        end
      else
        -- Reset checked routines back to ( )
        if is_undone == false then
          for i = start_row, actual_end_row do
            lines_to_uncheck[i] = true
          end
        end
      end
      return
    end

    for child in node:iter_children() do
      walk(child)
    end
  end

  for node in root:iter_children() do
    walk(node)
  end

  local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = {}
  for i, line in ipairs(all_lines) do
    local line_idx = i - 1
    if not lines_to_skip[line_idx] then
      if lines_to_uncheck[line_idx] then
        line = line:gsub("%-(%s*)%([xX%-_]%)", "-%1( )")
      end
      table.insert(result, line)
    end
  end

  vim.api.nvim_buf_delete(bufnr, { force = true })
  return remove_consecutive_empty_lines(result)
end

-- Build journal content from template, splicing in undone todos from previous journal.
-- Falls back to copying previous journal directly when no template exists.
local function filter_journal_content(filepath, workspace_dir)
  local template_path = workspace_dir .. "/.journalfiles/template.norg"
  local ok_read, template_lines = pcall(vim.fn.readfile, template_path)
  if not ok_read or not template_lines or #template_lines == 0 then
    return filter_previous_journal(filepath)
  end

  -- Extract undone todos from previous journal grouped by subsection
  local todos_by_subsection = extract_undone_todos(filepath)

  -- Build result from template, replacing placeholders with collected items
  local result = {}
  local in_todo_section = false
  local current_subsection = nil

  for _, line in ipairs(template_lines) do
    -- Track heading2 sections (** but not ***)
    if line:match("^%s*%*%*[^%*]") then
      if line:lower():match("to%s*do") then
        in_todo_section = true
      else
        in_todo_section = false
      end
      current_subsection = nil
    end

    -- Track heading3 subsections within TO DO
    if in_todo_section and line:match("^%s*%*%*%*[^%*]") then
      current_subsection = line:match("%*%*%*%s*(%w+)")
    end

    -- Replace placeholder with collected undone items
    if in_todo_section and current_subsection and line:match("^%s+%- %( %)%s*$") then
      local items = todos_by_subsection[current_subsection]
      if items and #items > 0 then
        for idx, item_lines in ipairs(items) do
          for _, item_line in ipairs(item_lines) do
            table.insert(result, item_line)
          end
          -- Blank line between items, but not after the last one
          if idx < #items then
            table.insert(result, "")
          end
        end
      else
        table.insert(result, line)
      end
    else
      table.insert(result, line)
    end
  end

  return remove_consecutive_empty_lines(result)
end

function M.continue_journal()
  local workspace_dir = validate_workspace()
  if not workspace_dir then
    return
  end

  local previous_journal = find_most_recent_journal(workspace_dir)

  if not previous_journal then
    vim.notify("No previous journal entries found", vim.log.levels.WARN)
    return
  end

  local ok, content = pcall(filter_journal_content, previous_journal, workspace_dir)

  if not ok then
    vim.notify("Failed to build journal: " .. tostring(content), vim.log.levels.ERROR)
    return
  end

  if #content == 0 then
    vim.notify("No content to continue from previous journal", vim.log.levels.INFO)
    return
  end

  -- Replace current buffer content
  local current_bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(current_bufnr, 0, -1, false, content)

  local date_match = previous_journal:match("(%d%d%d%d/%d%d/%d%d)%.norg$")
  vim.notify("Continued from journal: " .. (date_match or previous_journal), vim.log.levels.INFO)
end

return M
