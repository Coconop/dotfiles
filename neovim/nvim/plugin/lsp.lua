local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('williamboman/mason.nvim')
    require('mason').setup()
end)

later(function()
    add('stevearc/conform.nvim')

    require('conform').setup({
        -- Map of filetype to formatters
        formatters_by_ft = {
            javascript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            python = { "black" },
            rust = { "rustfmt", lsp_format = "fallback" },
        },
    })
end)

later(function()
    add('neovim/nvim-lspconfig')

    local custom_on_attach = function(client, buf_id)
        -- Set up 'mini.completion' LSP part of completion
        vim.bo[buf_id].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
        -- Mappings are created globally with `<Leader>l` prefix (for simplicity)
    end

    -- All language servers are expected to be installed with 'mason.vnim'
    local lspconfig = require('lspconfig')

    -- Bash
    --lspconfig.bashls.setup({ on_attach = custom_on_attach })

    -- Rust
    lspconfig.rust_analyzer.setup({ on_attach = custom_on_attach })

    -- C/C++
    lspconfig.clangd.setup({ on_attach = custom_on_attach })

    -- Lua
    lspconfig.lua_ls.setup({
        on_attach = function(client, bufnr)
            custom_on_attach(client, bufnr)
            -- Reduce unnecessarily long list of completion triggers for better
            -- 'mini.completion' experience
            client.server_capabilities.completionProvider.triggerCharacters = { '.', ':' }
        end,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    -- Get the language server to recognize common globals
                    globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'MiniDeps' },
                    disable = { 'need-check-nil' },
                    -- Don't make workspace diagnostic, as it consumes too much CPU and RAM
                    workspaceDelay = -1,
                },
                workspace = {
                    -- Don't analyze code from submodules
                    ignoreSubmodules = true,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    })

-- Python
--lspconfig.pyright.setup({ on_attach = custom_on_attach })

-- Typescript and Javascript
--lspconfig.ts_ls.setup({ on_attach = custom_on_attach })

-- Go
--lspconfig.gopls.setup({ on_attach = custom_on_attach })
end)

later(function() add('rafamadriz/friendly-snippets') end)

later(function ()
    add({
        source = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    })
    require("lsp_lines").setup()

    vim.diagnostic.config({
        -- Disable virtual_text since it's redundant due to lsp_lines.
        virtual_text = false,
        -- Don't underline HINTs, can be annoying with #[cfg()]
        underline = { severity = { min = vim.diagnostic.severity.INFO } },
    })
end)
