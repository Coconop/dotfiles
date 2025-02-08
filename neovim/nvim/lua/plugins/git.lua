return {
	{
		"rhysd/conflict-marker.vim",
        vim.keymap.set("n", "<leader>mn", "<cmd>ConflictMarkerNextHunk<cr>", { desc = "[M]erge Conflict [N]ext" }),
        vim.keymap.set("n", "<leader>mp", "<cmd>ConflictMarkerPrevHunk<cr>", { desc = "[M]erge Conflict [P]rev" }),
	},
	{ "lewis6991/gitsigns.nvim", opts = {} },
}
