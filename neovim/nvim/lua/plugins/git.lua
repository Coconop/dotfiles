return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]tatus" })
			vim.keymap.set("n", "<leader>gl", vim.cmd.Gclog, { desc = "[G]it [L]ogs" })
		end,
	},
	{
		"rhysd/conflict-marker.vim",
		vim.keymap.set("n", "<leader>cn", "<cmd>ConflictMarkerNextHunk<cr>", { desc = "[C]onflict [N]ext in file" }),
		vim.keymap.set("n", "<leader>cp", "<cmd>ConflictMarkerPrevHunk<cr>", { desc = "[C]onflict [P]rev in file" }),
	},
	{ "lewis6991/gitsigns.nvim", opts = {} },
}
