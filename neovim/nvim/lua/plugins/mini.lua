return {
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Extend and create a/i textobjects
			require("mini.ai").setup({ n_lines = 500 })
			-- Fast and feature-rich surround actions
			require("mini.surround").setup()
		end,
	},
}
