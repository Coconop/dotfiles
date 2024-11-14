-- Use space as leader key
vim.g.mapleader = " "

-- Spelling
vim.keymap.set('n', '<leader>ns', ':set spell<bar>normal! ]s<CR>', { desc = "Next misspell" },
    { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ps', ':set spell<bar>normal! [s<CR>', { desc = "Previous misspell" },
    { noremap = true, silent = true })

-- Easy System copy/paste
vim.keymap.set({ 'n', 'x' }, '<leader>yy', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>pp', '"+p', { desc = 'Paste from system clipboard' })

-- Buffer navigation
vim.keymap.set('n', '<leader>ll', vim.cmd.bn, { desc = "Next Vim buffer" })
vim.keymap.set('n', '<leader>hh', vim.cmd.bp, { desc = "Prev Vim buffer" })
