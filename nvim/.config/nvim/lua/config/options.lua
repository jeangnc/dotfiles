--- Leaders
vim.g.mapleader = "-"
vim.g.maplocalleader = "\\"

--- LazyVim / Plugin globals
vim.g.root_spec = { "cwd", ".git", "lua" }
vim.g.lazyvim_blink_main = true
vim.g.snacks_animate = false

--- UI
vim.opt.signcolumn = "yes:2"
vim.opt.laststatus = 3
vim.opt.clipboard = ""

--- Shell
vim.opt.shell = "/bin/zsh"
vim.opt.shellcmdflag = "-c"

--- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.LazyVim.treesitter.foldexpr()"
vim.opt.foldopen:remove("block")

--- Formatting
vim.opt.formatoptions:remove({ "r", "o" })

--- Build tools
vim.env.CXX = "g++"
