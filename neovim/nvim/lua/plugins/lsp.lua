local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- LSP client goes "Brrrr"
now(function()
    add({
        source = "neovim/nvim-lspconfig",
    })

    -- clangd specific
    -- For Makefile projects that have no CMakeLists (compile_commands.json)
    -- If there is one, just '-DCMAKE_EXPORT_COMPILE_COMMANDS=1'
    local function create_compile_flags()

        -- Try to automatically find where to put it
        local function find_project_root()
            local root_patterns = {'.git', 'Makefile' }
            local current_dir = vim.fn.expand('%:p:h')

            -- Look upwards until matching pattern or reaching '/'
            for _, pattern in ipairs(root_patterns) do
                local found = vim.fn.findfile(pattern, current_dir .. ';')
                if found ~= '' then
                    return vim.fn.fnamemodify(found, ':h')
                end
                found = vim.fn.finddir(pattern, current_dir .. ';')
                if found ~= '' then
                    return vim.fn.fnamemodify(found, ':h')
                end
            end

            -- fallback to current working dir
            vim.notify('No Root pattern found', vim.log.levels.WARN)
            return vim.fn.getcwd()
        end

        local project_root = find_project_root()
        local compile_flags_path = project_root .. '/compile_flags.txt'

        -- Check if file exists
        if vim.fn.filereadable(compile_flags_path) == 1 then
            vim.notify('compile_flags.txt already exists !', vim.log.levels.WARN)
            return
        end

        local default_flags = {
            '-Wall',
            '-Wextra',
            '-std=gnu99',
            '-pipe',
            '-fexceptions',
            '-fstack-protector-strong',
            '-fpic',
            '-I.',
            '-I./include',
            '-D_GNU_SOURCE'
        }

        -- Write the file
        local file = io.open(compile_flags_path, "w")
        if file then
            for _, flag in ipairs(default_flags) do
                file:write(flag .. '\n')
            end
            file:close()
            vim.notify('compile_flags.txt created at:' .. compile_flags_path, vim.log.levels.INFO)
            vim.notify('call gen_compile_db.sh', vim.log.levels.INFO)
        else
            vim.notify('Error: Could not create compile_flags.txt', vim.log.levels.ERROR)
        end
    end

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

            -- clangd specific
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.name == 'clangd' then
                map("<leader>lf", create_compile_flags,
                    "Create [f]ile compile_flags.txt")
            end
        end,
    })

    vim.keymap.set({ "n", "x" }, "<leader>vt", function()
        local current = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = not current })
        print("virtual_text: " .. tostring(not current))
    end, {desc = "[V]irtualText [T]ext Diagnostics Toggle"})

    vim.keymap.set({ "n", "x" }, "<leader>vl", function()
        local current = vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({ virtual_lines = not current })
        print("virtual_lines: " .. tostring(not current))
    end, {desc = "[V]irtual [L]ines Diagnostics Toggle"})

    vim.keymap.set({ "n", "x" }, "<leader>vu", function()
        local current = vim.diagnostic.config().underline
        vim.diagnostic.config({ underline = not current })
        print("underline: " .. tostring(not current))
    end, {desc = "[V]isual [U]nderlines Diagnostics Toggle"})

    -- Highlight entire line for errors
    -- Highlight the line number for warnings
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.HINT] = " ",
                [vim.diagnostic.severity.INFO] = " ",
            },
            linehl = {
                [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            },
            numhl = {
                [vim.diagnostic.severity.WARN] = 'WarningMsg',
            },
        },
        -- No distraction by default
        virtual_text = false,
        virtual_lines = false,
        underline = false,
    })
end)

-- Easily install LSP/DAP/Linters
now(function()
    add({
        source = "mason-org/mason.nvim",
    })
    require("mason").setup{}
end)

now(function()
    add({
        source = "mason-org/mason-lspconfig.nvim",
        depends = {"mason-org/mason.nvim"},
    })
    require("mason-lspconfig").setup{
        ensure_installed = {
            -- no rust_analyzer: shall use the one installed with rust
            "lua_ls",
            "clangd",
            "bashls",
            -- shellcheck Linter shall be installed manually
        },
        -- automatic_installation = true,
    }
end)
