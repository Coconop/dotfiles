-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
require("telescope").setup({
	defaults = {
        mappings = {
            i = {
                -- Ctrl+u clear prompt
                ["<C-u>"] = false
            },
        },
	},
	pickers = {
        live_grep = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            additional_args = function(_)
                return { "--hidden" }
            end
        },
		find_files = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            hidden = true,
			find_command = {
                'fd',
                '--type',
                'f',
                '--color=never',
                '--hidden',
                '--follow',
            }
		},
	},
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tg', builtin.live_grep, {desc = "Live Grep"})
vim.keymap.set('n', '<leader>td', builtin.diagnostics, {desc = "Browse diagnostics"})

-- use native fzf for a boost
require('telescope').load_extension('fzf')

