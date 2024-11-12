-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

function open_context(directory)
  -- vim.cmd("tabe")
  -- vim.cmd("tcd " .. directory)
  vim.cmd("Neotree action=focus dir=" .. directory)
end

-- opens nvim configs in neotree
vim.keymap.set("n", "<leader>ve", function()
  open_context("~/.dotfiles/nvim")
end, { desc = "Opens nvim configs for editing", silent = true, noremap = true })

-- to speed up browser searches
vim.keymap.set("n", "<leader>sb", function()
  vim.ui.input({ prompt = "Search query: " }, function(query)
    if query then
      local url = "https://www.google.com/search?q=" .. vim.fn.escape(query, " ")
      vim.fn.jobstart({ "open", url }, { detach = true })
    end
  end)
end, { desc = "Browser Search" })
