return {
    -- Use virtual lines to display accurate LSP diagnostics
    -- TODO Remove it when it reaches Neovim builtin !
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            -- Disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({ virtual_text = false })

            -- Don't underline HINTs, can be annoying with #[cfg()]
            vim.diagnostic.config({
                underline = { severity = { min = vim.diagnostic.severity.INFO } },
            })

            -- We want to be able to toggle it if its too annyoing
            vim.keymap.set("", "<Leader>vl", require("lsp_lines").toggle, { desc = "[V]irtual [L]ines toggle" })

            -- Disable for floating windows (Lazy, Mason)
            vim.api.nvim_create_autocmd("WinEnter", {
                callback = function()
                    local floating = vim.api.nvim_win_get_config(0).relative ~= ""
                    vim.diagnostic.config({
                        virtual_text = floating,
                        -- Keep it disabled by default
                        virtual_lines = false
                    })
                end,
            })
            -- Disable it by default, enable it via keymaps
            vim.diagnostic.config({ virtual_lines = false })
        end,
    },
}
