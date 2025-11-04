-- Use space as leader key
vim.g.mapleader = " "

-- Spelling
-- :set spell spellang=en_us
vim.keymap.set("n", "<leader>ns", ":set spell<bar>normal! ]s<CR>", { desc = "[N]ext [S]pelling" })
vim.keymap.set("n", "<leader>ps", ":set spell<bar>normal! [s<CR>", { desc = "[P]rev [S]pelling" })
vim.keymap.set("n", "<leader>vs", ":set spell<bar>normal! z=<CR>", { desc = "[V]iew [S]pell list" })

-- Easy System-Clipboard copy/paste
vim.keymap.set({ "n", "x" }, "<leader>yy", '"+y', { desc = "Copy Vim -> System" })
vim.keymap.set({ "n", "x" }, "<leader>pp", '"+p', { desc = "Paste System -> Vim" })

vim.keymap.set({ "n", "x" }, "<leader>yx", '"*y', { desc = "Copy Vim -> X11" })
vim.keymap.set({ "n", "x" }, "<leader>px", '"*p', { desc = "Paste X11 -> Vim" })

-- Easy Buffer navigation
vim.keymap.set("n", "<leader>ll", vim.cmd.bn, { desc = "Next Vim buffer" })
vim.keymap.set("n", "<leader>hh", vim.cmd.bp, { desc = "Prev Vim buffer" })

-- Tags
vim.keymap.set("n", "<leader>tj", "<C-]>", { desc = "{[T]ag [J]ump}" })

-- diff-mode (nvim -d)
vim.keymap.set("n", "<leader>nh", "]c<CR>", { desc = "[N]ext [H]unk" })
vim.keymap.set("n", "<leader>ph", "[c<CR>", { desc = "[P]rev [H]unk" })

-- :[range]diffg  Modify the current buffer to undo difference with another buffer
-- :[range]diffpu Modify another buffer to undo difference with the current buffer
