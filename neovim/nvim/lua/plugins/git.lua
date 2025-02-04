return {
	{
		"rhysd/conflict-marker.vim",
		vim.keymap.set("n", "<leader>cn", "<cmd>ConflictMarkerNextHunk<cr>", { desc = "[C]onflict [N]ext in file" }),
		vim.keymap.set("n", "<leader>cp", "<cmd>ConflictMarkerPrevHunk<cr>", { desc = "[C]onflict [P]rev in file" }),
	},
	{ "lewis6991/gitsigns.nvim", opts = {} },
}
