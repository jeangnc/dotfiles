-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set(
  "n",
  "<leader><tab>v",
  "<cmd>Neotree ~/.config/nvim<cr>",
  { desc = "Opens nvim configs for editing", silent = true, noremap = true }
)
