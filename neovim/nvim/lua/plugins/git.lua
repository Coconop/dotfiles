local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Easily visualize git conflicts
later(function()
    add({
		source = "rhysd/conflict-marker.vim",
    })
    vim.keymap.set("n", "<leader>nc", "<cmd>ConflictMarkerNextHunk<cr>", { desc = "[N]ext [C]onflict" })
    vim.keymap.set("n", "<leader>pc", "<cmd>ConflictMarkerPrevHunk<cr>", { desc = "[P]rev [C]onflict" })
end)

-- Work with diff hunks
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign'
        }
    })
    vim.keymap.set("n", "<leader>vh", ":lua MiniDiff.toggle_overlay()<CR>", { desc = "[V]iew [H]unks" })
end)
