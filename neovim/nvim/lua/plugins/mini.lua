return {
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Extend and create a/i textobjects
			require("mini.ai").setup({ n_lines = 500 })
			-- Fast and feature-rich surround actions
			require("mini.surround").setup()
			-- Visualize current scope
			require("mini.indentscope").setup({
				delay = 0,
				animation = function(n, s) return 0 end
			})
		end,
	},
	-- Handy comments
	{ 'echasnovski/mini.comment', version = false },
}
