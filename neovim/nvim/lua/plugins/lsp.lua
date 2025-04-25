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
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu"
        }
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

-- Use virtual lines to display accurate LSP diagnostics
-- TODO Remove it when it reaches Neovim builtin !
later(function()
    add({
        source = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    })
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
end)

