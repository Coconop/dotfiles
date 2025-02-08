return {
	-- Sweet pretty icons
	{ "nvim-tree/nvim-web-devicons", enabled = true, opts = {} },
	-- Fancy notifications
	{
		"rcarriga/nvim-notify",
		config = function()
			local notif = require("notify")
			notif.setup({
				render = "compact",
			})
			-- Use this plugin as default notification handler
			vim.notify = notif
			-- We want to be able to toggle it if its to annyoing
			vim.keymap.set("n", "<Leader>nn", notif.dismiss, { desc = "[N]otif [N]uke (clear)" })
			vim.keymap.set("n", "<Leader>nl", ":Notifications<CR>", { desc = "[N]otif [L]ist history" })
		end,
	},
	-- Pretty UI (floating windows)
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	-- Snitch on LSP doing
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
    -- Use virtual lines to display accurate LSP diagnostics
    -- TODO Remove it when it reaches Neovim builtin !
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            -- Disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({ virtual_text = false })

            -- Don't underline HINTs, can be annoying with #[cfg()]
            vim.diagnostic.config({
                underline = { severity = { min = vim.diagnostic.severity.INFO } },
            })

            -- We want to be able to toggle it if its to annyoing
            vim.keymap.set("", "<Leader>vl", require("lsp_lines").toggle, { desc = "[V]irtual [L]ines toggle" })

            -- Disable for floating windows (Lazy, Mason)
            vim.api.nvim_create_autocmd("WinEnter", {
                callback = function()
                    local floating = vim.api.nvim_win_get_config(0).relative ~= ""
                    vim.diagnostic.config({
                        virtual_text = floating,
                        -- Keep it disabled by default
                        virtual_lines = false
                    })
                end,
            })
            -- Disable it by default, enable it via keymaps
            vim.diagnostic.config({ virtual_lines = false })
        end,
    },
}
