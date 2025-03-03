local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Easily visualize git conflicts
later(function()
    add({
		source = "rhysd/conflict-marker.vim",
    })
    vim.keymap.set("n", "<leader>mn", "<cmd>ConflictMarkerNextHunk<cr>", { desc = "[M]erge Conflict [N]ext" })
    vim.keymap.set("n", "<leader>mp", "<cmd>ConflictMarkerPrevHunk<cr>", { desc = "[M]erge Conflict [P]rev" })
end)

-- Work with diff hunks
later(function() require('mini.diff').setup() end)
