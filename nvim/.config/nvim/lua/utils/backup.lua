local M = {}

local git_utils = require("utils.git")

local function handle_event(file_path, git_fn, should_backup)
  if not should_backup(file_path) then
    return
  end

  vim.schedule(function()
    git_fn(file_path)
  end)
end

function M.setup(opts)
  local augroup = vim.api.nvim_create_augroup(opts.augroup, { clear = true })
  local should_backup = opts.should_backup

  -- Auto-commit after save or create
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufNewFile" }, {
    group = augroup,
    pattern = opts.pattern,
    callback = function()
      local file_path = vim.fn.expand("%:p")
      handle_event(file_path, function(path)
        git_utils.async_add_and_commit(path, "Backup")
      end, should_backup)
    end,
    desc = "Auto-commit files on save",
  })

  if not opts.events then
    return
  end

  -- Handle file deletion
  if opts.events.file_deleted then
    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = opts.events.file_deleted,
      callback = function(event)
        handle_event(event.data.file_path, function(path)
          git_utils.async_remove_and_commit(path, "Backup")
        end, should_backup)
      end,
      desc = "Auto-commit file deletions",
    })
  end

  -- Handle file copy
  if opts.events.file_copied then
    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = opts.events.file_copied,
      callback = function(event)
        handle_event(event.data.new_path, function(path)
          git_utils.async_add_and_commit(path, "Backup")
        end, should_backup)
      end,
      desc = "Auto-commit file copies",
    })
  end

  -- Handle file move/rename
  if opts.events.file_moved then
    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = opts.events.file_moved,
      callback = function(event)
        local old_path = event.data.old_path
        local new_path = event.data.new_path

        if should_backup(old_path) and should_backup(new_path) then
          vim.schedule(function()
            git_utils.async_move_and_commit(old_path, new_path, "Backup")
          end)
        end
      end,
      desc = "Auto-commit file moves",
    })
  end
end

return M
