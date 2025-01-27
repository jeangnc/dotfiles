-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local group = vim.api.nvim_create_augroup("autoview", { clear = true })

-- creates a view when leading the file
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
  group = group,
  pattern = "*",
  callback = function()
    vim.cmd.mkview({ mods = { emsg_silent = true } })
  end,
})

-- reads view after buffer is readed
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "*",
  callback = function()
    -- defers execution, otherwise doesn't work when the file is opened
    vim.defer_fn(function()
      vim.cmd.loadview({ mods = { emsg_silent = true } })
    end, 0)
  end,
})
