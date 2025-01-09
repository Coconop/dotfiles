return {
    -- LSP settings by language
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.rust_analyzer.setup({
                settings = {
                    ['rust-analyzer'] = {
                        chechOnSave = {
                            command = "clippy"
                        }
                    }
                }
            })
        end
    },

    -- Use virtual lines to display accurate LSP diagnostics
    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
            require("lsp_lines").setup()
            -- Disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({ virtual_text = false })
            -- -- Don't underline HINTs, can be annoying with #[cfg()]
            vim.diagnostic.config {
                underline = { severity = { min = vim.diagnostic.severity.INFO } },
            }
            -- We want to be able to toggle it if its to annyoing
            vim.keymap.set(
                "",
                "<Leader>vl",
                require("lsp_lines").toggle,
                { desc = "Toggle lsp virtual_lines" }
            )
        end
    },

    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = {"ConformInfo"},
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>cf",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {-- Define your formatters
            formatters_by_ft = {
                --lua = { "stylua" },
                --python = { "isort", "black" },
                rust = {"rustfmt"},
            },
            -- Set default options
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- Set up format-on-save
            format_on_save = { timeout_ms = 500 },
            -- Customize formatters
            --formatters = {
            --    shfmt = {
            --        prepend_args = { "-i", "2" },
            --    },
            --},
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

}
