return {
	{ "nvim-tree/nvim-web-devicons", opts = {} },
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
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "[F]ind [T]odo" }),
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}
