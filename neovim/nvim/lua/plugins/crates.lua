return {
    {
        'saecki/crates.nvim',
        event = { "BufRead Cargo.toml" },
        config = function()
            require('crates').setup()
            local crates = require('crates')
            local opts = { silent = true }

            vim.keymap.set("n", "<leader>ct", crates.toggle, { desc = "Toggle" }, opts)
            vim.keymap.set("n", "<leader>cr", crates.reload, { desc = "Reload" }, opts)

            vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { desc = "Popup version" }, opts)
            vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Popup features" }, opts)
            vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, { desc = "Popup dependencies" }, opts)

            vim.keymap.set("n", "<leader>ca", crates.update_all_crates, { desc = "Upd All Crates" }, opts)

            vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, { desc = "Expand Crate" }, opts)
            vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, { desc = "Extract Crate" }, opts)

            vim.keymap.set("n", "<leader>cR", crates.open_repository, { desc = "crate github" }, opts)
            vim.keymap.set("n", "<leader>cD", crates.open_documentation, { desc = "crate doc" }, opts)
            vim.keymap.set("n", "<leader>cC", crates.open_crates_io, { desc = "crates.io" }, opts)
        end,
    }
}
