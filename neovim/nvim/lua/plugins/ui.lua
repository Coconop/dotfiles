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
			vim.keymap.set("n", "<Leader>nd", notif.dismiss, { desc = "Clear all currently displayed notifications" })
			vim.keymap.set("n", "<Leader>nl", ":Notifications<CR>", { desc = "List notification history" })
		end,
	},
}
