vim.loader.enable()

-- General (Neo)Vim settings
require("config.options")
-- Neovim keybindings
require("config.keymaps")
-- Custom autocommands
require("config.autocmd")
-- Plugin Manager
require("config.mini")
-- Plugins
require('plugins.ui')
require('plugins.navigation')
require('plugins.editing')
require('plugins.code')
require('plugins.filetype')
require('plugins.lsp')
require('plugins.git')
