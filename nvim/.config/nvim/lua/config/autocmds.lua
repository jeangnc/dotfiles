-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = require("utils.common").augroup

augroup("autoview", function(autocmd)
  -- creates a view when leaving the file
  autocmd({ "BufWinLeave", "BufWritePost" }, {
    pattern = "*",
    callback = function(event)
      if vim.b[event.buf].view then
        vim.cmd.mkview({ mods = { emsg_silent = true } })
      end
    end,
  })

  -- reads view after buffer is loaded but preserves current directory
  autocmd("BufReadPost", {
    pattern = "*",
    callback = function(event)
      local current_dir = vim.fn.getcwd()
      vim.cmd.loadview({ mods = { emsg_silent = true } })
      vim.cmd.cd(current_dir) -- restore original directory
      vim.b[event.buf].view = true
    end,
  })
end)

augroup("terminal_settings", function(autocmd)
  autocmd("TermOpen", {
    callback = function()
      vim.opt_local.signcolumn = "no"
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.statuscolumn = ""
      vim.opt_local.spell = false
      vim.opt_local.cursorline = false
    end,
  })
end)

augroup("toggle_line_number", function(autocmd)
  autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      vim.wo.relativenumber = false
    end,
  })

  autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      vim.wo.relativenumber = true
    end,
  })
end)

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
