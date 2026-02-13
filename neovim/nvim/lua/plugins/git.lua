local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Navigate git conflicts
vim.keymap.set("n", "<leader>nc", function()
    vim.fn.search("^<<<<<<<\\|^=======\\|^>>>>>>>", "W")
end, { desc = "[N]ext [C]onflict" })

vim.keymap.set("n", "<leader>pc", function()
    vim.fn.search("^<<<<<<<\\|^=======\\|^>>>>>>>", "bW")
end, { desc = "[P]rev [C]onflict" })

-- Work with diff hunks
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign'
        }
    })
    vim.keymap.set("n", "<leader>vh", ":lua MiniDiff.toggle_overlay()<CR>", { desc = "[V]iew [H]unks" })
end)
