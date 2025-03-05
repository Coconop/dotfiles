-- Use space as leader key
vim.g.mapleader = " "

-- Spelling
-- :set spell spellang=en_us
vim.keymap.set("n", "<leader>zn", ":set spell<bar>normal! ]s<CR>", { desc = "Move to next misspell" })
vim.keymap.set("n", "<leader>zp", ":set spell<bar>normal! [s<CR>", { desc = "Move to prev misspell" })
vim.keymap.set("n", "<leader>zs", ":set spell<bar>normal! z=<CR>", { desc = "Open suggest list" })

-- Easy System-Clipboard copy/paste
vim.keymap.set({ "n", "x" }, "<leader>yy", '"+y', { desc = "Copy Vim -> System" })
vim.keymap.set({ "n", "x" }, "<leader>pp", '"+p', { desc = "Paste System -> Vim" })

-- Easy Buffer navigation
vim.keymap.set("n", "<leader>ll", vim.cmd.bn, { desc = "Next Vim buffer" })
vim.keymap.set("n", "<leader>hh", vim.cmd.bp, { desc = "Prev Vim buffer" })

-- Tags
vim.keymap.set("n", "<leader>tj", "<C-]>", { desc = "{[T]ag [J]ump}" })

