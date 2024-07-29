vim.cmd('packadd termdebug')
vim.api.nvim_set_keymap('n', '<leader>dt', ':TermDebug<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>db', ':Break<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>du', ':Clear<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ':Run<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':Continue<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dn', ':Next<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ds', ':Step<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>df', ':Finish<CR>', { noremap = true, silent = true })
vim.g.termdebugger = 'rust-gdb'
vim.g.termdebugger_wide = 1
vim.g.termdebug_config['winbar'] = 0
