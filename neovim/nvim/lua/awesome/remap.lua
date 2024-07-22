vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex, {desc = "File Explorer"})
vim.keymap.set('n', '<leader>ns', ':set spell<bar>normal! ]s<CR>', {desc = "Next misspell"}, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>ps', ':set spell<bar>normal! [s<CR>', {desc = "Previous misspell"}, {noremap = true, silent = true})
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
