return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" });
            vim.keymap.set("n", "<leader>gl", vim.cmd.Gclog, { desc = "Git Logs" });
        end
    },
    { "rhysd/conflict-marker.vim",
        vim.keymap.set("n", "<leader>nc", "<cmd>ConflictMarkerNextHunk<cr>"),
        vim.keymap.set("n", "<leader>pc", "<cmd>ConflictMarkerPrevHunk<cr>"),
    },
    {
        "rbong/vim-flog",
        config = function()
            vim.keymap.set("n", '<leader>gg', vim.cmd.Flog, { desc = "Git Graph" })
        end
    },
    { "lewis6991/gitsigns.nvim", opts = {} },
}
