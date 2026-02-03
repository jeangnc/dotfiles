-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autoview = vim.api.nvim_create_augroup("autoview", { clear = true })

-- creates a view when leaving the file
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
  group = autoview,
  pattern = "*",
  callback = function(event)
    if vim.b[event.buf].view then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})

-- reads view after buffer is loaded but preserves current directory
vim.api.nvim_create_autocmd("BufReadPost", {
  group = autoview,
  pattern = "*",
  callback = function(event)
    local current_dir = vim.fn.getcwd()
    vim.cmd.loadview({ mods = { emsg_silent = true } })
    vim.cmd.cd(current_dir) -- restore original directory
    vim.b[event.buf].view = true
  end,
})

local linenumber_group = vim.api.nvim_create_augroup("toggle_line_number", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = linenumber_group,
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = linenumber_group,
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,
})

local terminal_group = vim.api.nvim_create_augroup("terminal_window_management", { clear = true })

-- Equalize windows when terminal opens
-- Disabled: conflicts with claudecode.nvim's split_width_percentage,
-- causing terminal rendering glitches when the window gets resized 100ms after opening.
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = terminal_group,
--   pattern = "*",
--   callback = function()
--     vim.defer_fn(function()
--       vim.cmd("wincmd =")
--     end, 100)
--   end,
--   desc = "Equalize windows when terminal opens",
-- })

-- Notify LSP servers when files change externally (e.g., via claudecode.nvim)
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    if #clients == 0 then
      return
    end
    local uri = vim.uri_from_fname(vim.api.nvim_buf_get_name(args.buf))
    local changes = { { uri = uri, type = 2 } } -- FileChangeType.Changed
    for _, client in ipairs(clients) do
      client:notify("workspace/didChangeWatchedFiles", { changes = changes })
    end
  end,
  desc = "Notify LSP servers when files change externally",
})
