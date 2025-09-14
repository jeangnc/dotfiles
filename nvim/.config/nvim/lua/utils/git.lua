local M = {}

function M.async_add_and_commit(file_path, commit_message)
  local git_dir = vim.fn.fnamemodify(file_path, ":h")
  local relative_path = vim.fn.fnamemodify(file_path, ":t")

  vim.system({
    "git",
    "add",
    relative_path,
  }, {
    cwd = git_dir,
  }, function(result)
    if result.code == 0 then
      vim.system({
        "git",
        "commit",
        "-m",
        commit_message or "Backup",
      }, {
        cwd = git_dir,
      })
    end
  end)
end

function M.async_remove_and_commit(file_path, commit_message)
  local git_dir = vim.fn.fnamemodify(file_path, ":h")
  local relative_path = vim.fn.fnamemodify(file_path, ":t")

  vim.system({
    "git",
    "rm",
    relative_path,
  }, {
    cwd = git_dir,
  }, function(result)
    if result.code == 0 then
      vim.system({
        "git",
        "commit",
        "-m",
        commit_message or "Backup",
      }, {
        cwd = git_dir,
      })
    end
  end)
end

function M.async_move_and_commit(old_path, new_path, commit_message)
  local git_dir = vim.fn.fnamemodify(new_path, ":h")
  local old_relative = vim.fn.fnamemodify(old_path, ":t")
  local new_relative = vim.fn.fnamemodify(new_path, ":t")

  vim.system({
    "git",
    "mv",
    old_relative,
    new_relative,
  }, {
    cwd = git_dir,
  }, function(result)
    if result.code == 0 then
      vim.system({
        "git",
        "commit",
        "-m",
        commit_message or "Backup",
      }, {
        cwd = git_dir,
      })
    end
  end)
end

return M

