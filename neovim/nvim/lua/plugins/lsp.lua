return {
    {
        'hrsh7th/cmp-nvim-lsp'
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets'
        }
    },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            require("luasnip.loaders.from_vscode").lazy_load()

            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                snippet = {
                    expand = function(args)
                        require 'luasnip'.lsp_expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    -- { name = 'luasnip', option = { use_show_condition = false } },
                    -- more sources
                }, {
                    { name = "buffer" },
                }),
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.rust_analyzer.setup({
                settings = {
                    ['rust_analyzer'] = {
                        checkOnSave = {
                            command = "clippy"
                        }
                    },
                },
            })
            lspconfig.lua_ls.setup({
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = {'vim'},
                            workspaceDelay = -1,
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                                -- Depending on the usage, you might want to add additional paths here.
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        },
                        telemetry = {
                            enable = false,
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            })
        end
    },
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup({
                PATH = 'append'
            })
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    "lua_ls",
                    --"rust_analyzer"
                },
                -- Use system install
                automatic_installation = { exclude = { "rust_analyzer" } },
                handlers = {
                    --- this first function is the "default handler"
                    --- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                },
            })
        end
    },
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
            vim.keymap.set(
                "",
                "<Leader>vl",
                require("lsp_lines").toggle,
                { desc = "Toggle lsp virtual_lines" }
            )
        end
    },
    {
        'stevearc/conform.nvim','stevearc/conform.nvim',
		config = function ()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
        end
    },
}
