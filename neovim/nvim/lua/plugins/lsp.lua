local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- LSP client goes "Brrrr"
later(function()
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

            map("<leader>ld", require("fzf-lua").lsp_definitions,
            "goto [d]efinition")
            map("<leader>lh", vim.lsp.buf.declaration, "goto declaration")
            map("<leader>lr", require("fzf-lua").lsp_references,
            "goto [r]eferences")
            map("<leader>lI", require("fzf-lua").lsp_implementations,
            "goto [I]mplementation")
            map("<leader>lt", require("fzf-lua").lsp_typedefs,
            "goto [T]ype definition")
            map("<leader>ls", require("fzf-lua").lsp_document_symbols,
            "document [S]ymbols")
            map("<leader>lR", vim.lsp.buf.rename, "[R]ename")
            map("<leader>la", vim.lsp.buf.code_action, "code [a]ction", { "n", "x" })
            map("<leader>lci", require("fzf-lua").lsp_incoming_calls, "[I]ncoming calls")
            map("<leader>lco", require("fzf-lua").lsp_outgoing_calls, "[O]utgoing calls")
            map("<leader>le", require("fzf-lua").diagnostics_document, "list Diagnostics [e]rrors")

            -- clangd specific
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.name == 'clangd' then
                map("<leader>lf", create_compile_flags,
                    "Create [f]ile compile_flags.txt")
            end
        end,
    })

    vim.keymap.set({ "n", "x" }, "<leader>dvt", function()
        local current = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = not current })
        print("virtual_text: " .. tostring(not current))
    end, {desc = "[D]iagnostic [V]irtual [T]ext toogle"})

    vim.keymap.set({ "n", "x" }, "<leader>dvl", function()
        local current = vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({ virtual_lines = not current })
        print("virtual_lines: " .. tostring(not current))
    end, {desc = "[D]iagnostic [V]irtual [L]ines toogle"})

    vim.keymap.set({ "n", "x" }, "<leader>du", function()
        local current = vim.diagnostic.config().underline
        vim.diagnostic.config({ underline = not current })
        print("underline: " .. tostring(not current))
    end, {desc = "[D]iagnostic [U]nderline toogle"})

    vim.keymap.set("n", "<leader>dn", function()
        vim.diagnostic.jump({count=1, float=true}) end,
        {desc = "[D]iagnostic [N]ext "})
    vim.keymap.set("n", "<leader>dp", function()
        vim.diagnostic.jump({count=-1, float=true}) end,
        {desc = "[D]iagnostic [P]rev"})

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
        underline = true,
    })

    vim.keymap.set({ "n" }, "<leader>i", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
    end, {desc = "[i]nlay Hints toggle"})

    -- Rust analyzer specific (not handled by Mason)
    vim.lsp.config('rust_analyzer', {
        settings = {
            ['rust-analyzer'] = {
                chechOnSave = {
                    command = "clippy",
                },
                inlayHints = {
                    bindingModeHints = {
                        enable = false,
                    },
                    chainingHints = {
                        enable = true,
                    },
                    closingBraceHints = {
                        enable = true,
                        minLines = 25,
                    },
                    closureReturnTypeHints = {
                        enable = "never",
                    },
                    lifetimeElisionHints = {
                        enable = "never",
                        useParameterNames = false,
                    },
                    maxLength = 25,
                    parameterHints = {
                        enable = true,
                    },
                    reborrowHints = {
                        enable = "never",
                    },
                    renderColons = true,
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
            },
        },
    })

    vim.keymap.set("n", "<leader>lg", function()
        vim.notify("Enabling LSP")
        vim.lsp.enable('rust_analyzer')
        vim.lsp.enable('clangd')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('pyright')
    end, { desc = "[L]SP [g]o"})

    vim.keymap.set("n", "<leader>lx", function()
        vim.notify("Disabling LSP")
        for _, client in ipairs(vim.lsp.get_clients()) do
            client.stop()
        end
        vim.lsp.enable('rust_analyzer', false)
        vim.lsp.enable('clangd', false)
        vim.lsp.enable('lua_ls', false)
        vim.lsp.enable('pyright', false)
    end, { desc = "[L]SP e[x]it"})


    vim.keymap.set("n", "<leader>sc", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(bufnr)

      vim.fn.jobstart({ "shellcheck", "--format=json", filename }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if not data then return end
          local output = table.concat(data, "\n")
          local ok, result = pcall(vim.fn.json_decode, output)
          if not ok or not result then return end

          local diagnostics = {}
          for _, item in ipairs(result) do
            table.insert(diagnostics, {
              lnum = item.line - 1,
              col = item.column - 1,
              end_lnum = item.endLine - 1,
              end_col = item.endColumn,
              severity = item.level == "error" and vim.diagnostic.severity.ERROR
                      or item.level == "warning" and vim.diagnostic.severity.WARN
                      or vim.diagnostic.severity.INFO,
              message = item.message,
              source = "shellcheck",
            })
          end

          vim.diagnostic.set(vim.api.nvim_create_namespace("shellcheck"), bufnr, diagnostics)
        end,
      })
    end, { desc = "[S]hell[C]heck"})

    -- Global clear (all namespaces)
    vim.keymap.set("n", "<leader>dc", function()
        vim.diagnostic.reset(nil, 0)
    end, { desc = "[D]iagnostic [C]lear"})

end)

-- Easily install LSP/DAP/Linters
later(function()
    add({
        source = "mason-org/mason.nvim",
    })
    require("mason").setup{}
end)

later(function()
    -- Prefer system install (especially on isolated VM)
    local use_sys_inst = vim.fn.executable("clangd") == 1
    add({
        source = "mason-org/mason-lspconfig.nvim",
        depends = {"mason-org/mason.nvim"},
    })
    require("mason-lspconfig").setup{
        ensure_installed = use_sys_inst and {} or {
            -- no rust_analyzer: shall use the one installed with rustup
            "lua_ls",
            "clangd",
            "bashls",
            -- shellcheck Linter shall be installed manually
        },
    }
end)

-- Jenkins linter (not a real LSP but kinda)
later(function()
    add({
        source = "ckipp01/nvim-jenkinsfile-linter",
        depends = {"nvim-lua/plenary.nvim"}
    })

    local linter = require('jenkinsfile_linter')

    vim.keymap.set('n', '<leader>jl', function()
        linter.validate()
    end, { desc = "[J]enkinsfile [L]int" })

end)
