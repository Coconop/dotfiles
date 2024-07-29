return {
    {
        'williamboman/mason.nvim',
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig() -- Need to be call 1st !
            -- Enable keybindings only when LSP is active
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                lsp_zero.default_keymaps({ buffer = bufnr })
                -- Custom bindings
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'Find LSP References' },
                    { buffer = bufnr })
            end)

            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
            require('mason').setup({})
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer", },
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
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ['rust_analyzer'] = { 'rust' },
                    ['lua_ls'] = { 'lua' },
                }
            })
        end
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
            })
        end
    },
    { 'L3MON4D3/LuaSnip' },
}
