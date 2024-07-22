vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex, {desc = "File Explorer"})
vim.keymap.set('n', '<leader>ns', ']s', {noremap = true, silent = true}, {desc = "Next spelling erro"})
vim.keymap.set('n', '<leader>ps', '[s', {noremap = true, silent = true})
