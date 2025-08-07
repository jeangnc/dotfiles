-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- don't change cwd when find a .git
vim.g.root_spec = { "cwd" }

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

-- recommended by avante
vim.opt.laststatus = 3

-- uses zsh and loads aliases
vim.opt.shell = "/bin/zsh"
vim.opt.shellcmdflag = "-ic"
