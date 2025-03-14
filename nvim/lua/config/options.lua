-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "-"
vim.g.maplocalleader = "\\"
vim.opt.signcolumn = "yes:2"

-- disables integration with global clipboard
vim.opt.clipboard = ""

--
vim.g.lazyvim_blink_main = true
vim.g.snacks_animate = false

-- Highlight the 80th and 100th columns
-- vim.opt.colorcolumn = "80,100"
vim.cmd([[highlight ColorColumn ctermbg=lightgrey guibg=lightgrey]])
