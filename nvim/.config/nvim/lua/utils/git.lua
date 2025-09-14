local M = {}
local common = require("utils.common")
local file = require("utils.file")

-- ============================================================================
-- Private Helper Functions
-- ============================================================================

local function async_git_commit(git_dir, commit_message)
  local commit_args = { "git", "commit", "-m", commit_message or "Backup" }
  local commit_opts = { cwd = git_dir }

  common.execute_async_command(commit_args, commit_opts)
end

local function async_git_operation(file_path, git_args, commit_message)
  local git_dir = file.get_directory(file_path)
  local relative_path = file.get_filename(file_path)

  local operation_args = vim.list_extend({ "git" }, git_args)
  table.insert(operation_args, relative_path)

  local operation_opts = { cwd = git_dir }

  common.execute_async_command(operation_args, operation_opts, function(result)
    if result.code == 0 then
      async_git_commit(git_dir, commit_message)
    end
  end)
end

-- ============================================================================
-- Public API
-- ============================================================================

function M.async_add_and_commit(file_path, commit_message)
  async_git_operation(file_path, { "add" }, commit_message)
end

function M.async_remove_and_commit(file_path, commit_message)
  async_git_operation(file_path, { "rm" }, commit_message)
end

function M.async_move_and_commit(old_path, new_path, commit_message)
  local git_dir = file.get_directory(new_path)
  local old_relative = file.get_filename(old_path)
  local new_relative = file.get_filename(new_path)

  local move_args = { "git", "mv", old_relative, new_relative }
  local move_opts = { cwd = git_dir }

  common.execute_async_command(move_args, move_opts, function(result)
    if result.code == 0 then
      async_git_commit(git_dir, commit_message)
    end
  end)
end

return M