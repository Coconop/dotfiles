local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Navigate merge conflicts
vim.keymap.set("n", "<leader>mn", function()
    vim.fn.search("^<<<<<<<\\|^=======\\|^>>>>>>>", "W")
end, { desc = "[M]erge conflict [N]ext" })

vim.keymap.set("n", "<leader>mp", function()
    vim.fn.search("^<<<<<<<\\|^=======\\|^>>>>>>>", "bW")
end, { desc = "[M]erge conflict [P]rev" })

-- Work with diff hunks
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign',
            signs = { add='+', change='~', delete='-'}
        }
    })
    vim.keymap.set("n", "<leader>md", ":lua MiniDiff.toggle_overlay()<CR>", { desc = "[M]ini [D]iff" })
end)
