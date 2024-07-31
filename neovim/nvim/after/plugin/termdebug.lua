vim.cmd('packadd termdebug')
vim.api.nvim_set_keymap('n', '<leader>tdt', ':Termdebug<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tdb', ':Break<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tdu', ':Clear<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tdr', ':Run<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tdc', ':Continue<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tdn', ':Next<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tds', ':Step<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tdf', ':Finish<CR>', { noremap = true, silent = true })
vim.g.termdebugger = 'rust-gdb'
vim.g.termdebug_wide = 163
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' }, { silent = true })
