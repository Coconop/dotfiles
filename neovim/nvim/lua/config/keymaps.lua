-- Use space as leader key
vim.g.mapleader = " "

-- Spelling
-- :set spell spellang=en_us
vim.keymap.set("n", "<leader>zn", ":set spell<bar>normal! ]s<CR>", { desc = "next spelling" })
vim.keymap.set("n", "<leader>zp", ":set spell<bar>normal! [s<CR>", { desc = "prev spelling" })
vim.keymap.set("n", "<leader>zs", ":set spell<bar>normal! z=<CR>", { desc = "open spell suggestions" })
vim.keymap.set("n", "<leader>za", ":set spell<bar>normal! zg<CR>", { desc = "add spell to dict" }) -- zug to undo

-- Easy System-Clipboard copy/paste
vim.keymap.set({ "n", "x" }, "<leader>yy", '"+y', { desc = "Copy Vim -> System" })
vim.keymap.set({ "n", "x" }, "<leader>pp", '"+p', { desc = "Paste System -> Vim" })

vim.keymap.set({ "n", "x" }, "<leader>yx", '"*y', { desc = "Copy Vim -> X11" })
vim.keymap.set({ "n", "x" }, "<leader>px", '"*p', { desc = "Paste X11 -> Vim" })

vim.keymap.set({"n", "v"}, "<leader>x", '"_d"', { desc = "Void Delete (no Yank)"})

-- Easy Buffer navigation
vim.keymap.set("n", "<leader>ll", vim.cmd.bn, { desc = "Next Vim buffer" })
vim.keymap.set("n", "<leader>hh", vim.cmd.bp, { desc = "Prev Vim buffer" })

-- Tags
vim.keymap.set("n", "<leader>tj", "<C-]>", { desc = "{[T]ag [J]ump}" })

-- diff-mode (nvim -d)
vim.keymap.set("n", "<leader>hn", "]c<CR>", { desc = "[H]unk [N]ext" })
vim.keymap.set("n", "<leader>hp", "[c<CR>", { desc = "[H]unk [P]rev" })
-- :[range]diffg  Modify the current buffer to undo difference with another buffer
-- :[range]diffpu Modify another buffer to undo difference with the current buffer

-- Smart formatting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>pf", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path) --copy filepath
	print("file:", path) -- show it
end, { desc = "[P]ath [F]ile Copy" })
