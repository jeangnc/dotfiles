-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- find project root using cwd first, then .git, then lua dirs
vim.g.root_spec = { "cwd", ".git", "lua" }

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
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "lightgrey", bg = "lightgrey" })

-- recommended by avante
vim.opt.laststatus = 3

-- uses zsh and loads aliases
vim.opt.shell = "/bin/zsh"
vim.opt.shellcmdflag = "-ic"

-- prevent folds from opening when navigating with paragraph motions
vim.opt.foldopen:remove("block")

-- disable auto-continuation of bullet points and numbered lists
vim.opt.formatoptions:remove({ "r", "o" })

-- Set CXX for tree-sitter-norg C++ scanner compilation
vim.env.CXX = "g++"
