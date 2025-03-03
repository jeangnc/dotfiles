-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autoview = vim.api.nvim_create_augroup("autoview", { clear = true })

-- creates a view when leading the file
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
  group = autoview,
  pattern = "*",
  callback = function(event)
    if vim.b[event.buf].view then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})

-- reads view after buffer is readed
vim.api.nvim_create_autocmd("BufReadPost", {
  group = autoview,
  pattern = "*",
  callback = function(event)
    -- defers execution, otherwise doesn't work when the file is opened
    vim.cmd.loadview({ mods = { emsg_silent = true } })
    vim.b[event.buf].view = true
  end,
})

local linenumber_group = vim.api.nvim_create_augroup("toggle_line_number", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = linenumber_group,
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = linenumber_group,
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end,
})
