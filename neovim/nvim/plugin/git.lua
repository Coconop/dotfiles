
local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('rhysd/conflict-marker.vim')
    vim.keymap.set("n", "<leader>nc", "<cmd>ConflictMarkerNextHunk<cr>")
    vim.keymap.set("n", "<leader>pc", "<cmd>ConflictMarkerPrevHunk<cr>")
end)

