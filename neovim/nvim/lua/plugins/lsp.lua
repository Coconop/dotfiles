local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- LSP client goes "Brrrr"
now(function()
    add({
        source = "neovim/nvim-lspconfig",
    })

    local lspconfig = require("lspconfig")
    local caps = vim.lsp.protocol.make_client_capabilities()

    -- Global lsp config ----------------------------------------------

    -- Always let space for diagnostics, signs, etc
    vim.opt.signcolumn = "yes"

    -- Setup keymaps etc ONLY if there is an attached LSP
    vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
            local map = function(keys, func, desc, mode)
                mode = mode or "n"
                vim.keymap.set(mode, keys, func,
                { buffer = event.buf, desc = "LSP: " .. desc })
            end
            map("<leader>ld", require("telescope.builtin").lsp_definitions,
            "goto [D]efinition")
            map("<leader>lD", vim.lsp.buf.declaration, "goto [D]eclaration")
            map("<leader>lr", require("telescope.builtin").lsp_references,
            "goto [R]eferences")
            map("<leader>lI", require("telescope.builtin").lsp_implementations,
            "goto [I]mplementation")
            map("<leader>lt", require("telescope.builtin").lsp_type_definitions,
            "goto [T]ype definition")
            map("<leader>ls", require("telescope.builtin").lsp_document_symbols,
            "document [S]ymbols")
            map("<leader>lR", vim.lsp.buf.rename, "[R]ename")
            map("<leader>lc", vim.lsp.buf.code_action, "[C]ode action", { "n", "x" })
        end,
    })

    -- Add autocompletion for all languages (disabled for mini)
    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Change diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Per language config --------------------------------------------

    -- Rust
    lspconfig.rust_analyzer.setup({
        capabilities = caps,
        settings = {
            ["rust-analyzer"] = {
                chechOnSave = {
                    command = "clippy",
                },
            },
        },
    })

    -- C/C++ (requires cmake OR bear+Makefile OR compile_flags.txt)
    lspconfig.clangd.setup({
        capabilities = caps,
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
        },
        init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true
        },
    })

    -- Bash
    -- lspconfig.bashls.setup({
    --     capabilities = caps,
    -- })

    -- Lua (Neovim)
    lspconfig.lua_ls.setup({
        capabilities = caps,
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                    workspaceDelay = -1,
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
                telemetry = {
                    enable = false,
                },
            })
        end,
        settings = {
            Lua = {},
        },
    })
end)

