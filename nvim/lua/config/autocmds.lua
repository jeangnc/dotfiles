-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
  pattern = { "*" },
  callback = function(event)
    vim.cmd.mkview({ mods = { emsg_silent = true } })
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*" },
  callback = function(event)
    vim.cmd.loadview({ mods = { emsg_silent = true } })
  end,
})
