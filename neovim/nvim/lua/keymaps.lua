-- Use space as leader key
vim.g.mapleader = " "

-- Spelling
vim.keymap.set("n", "<leader>sn", ":set spell<bar>normal! ]s<CR>", { desc = "Next [S]pell" })
vim.keymap.set("n", "<leader>sp", ":set spell<bar>normal! [s<CR>", { desc = "Previous [S]pell" })

-- Easy System copy/paste
vim.keymap.set({ "n", "x" }, "<leader>yy", '"+y', { desc = "Copy Vim -> System" })
vim.keymap.set({ "n", "x" }, "<leader>pp", '"+p', { desc = "Paste System -> Vim" })

-- Buffer navigation
vim.keymap.set("n", "<leader>ll", vim.cmd.bn, { desc = "Next Vim buffer" })
vim.keymap.set("n", "<leader>hh", vim.cmd.bp, { desc = "Prev Vim buffer" })
