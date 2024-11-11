-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy the whole line to clipboard" })

vim.keymap.set(
  "n",
  "<leader><tab>v",
  "<cmd>Neotree ~/.config/nvim<cr>",
  { desc = "Opens nvim configs for editing", silent = true, noremap = true }
)
