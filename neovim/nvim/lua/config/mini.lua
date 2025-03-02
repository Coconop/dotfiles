-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
  vim.o.termguicolors = true
  -- vim.cmd('colorscheme catppuccin')
end)

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
  vim.keymap.set("n", "<leader>ns", ":lua require('mini.notify').show_history()<CR>", { desc = "[N]otifications [S]how" })
end)

now(function()
    require('mini.icons').setup()
    require('mini.icons').mock_nvim_web_devicons()
end)

now(function() require('mini.clue').setup({
    triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- -- `z` key
    -- { mode = 'n', keys = 'z' },
    -- { mode = 'x', keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    -- require('mini.clue').gen_clues.z(),
  },
}) end)

now(function()
    add({
        source = 'catppuccin/nvim',
		name = "catppuccin",
    })
    vim.cmd([[colorscheme catppuccin-mocha]])
end)

-- Safely execute later
later(function() require('mini.ai').setup() end)
later(function() require('mini.comment').setup() end)
-- later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.indentscope').setup({
    delay = 0,
    animation = function(n, s) return 0 end
}) end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.hipatterns').setup({
    highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
}) end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.cursorword').setup() end)

later(function()
    require('mini.files').setup()
    vim.keymap.set("n", "<leader>fe", ":lua MiniFiles.open()<CR>", { desc = "File [Ex]plorer" })
end)

now(function()
    add({
        source = 'christoomey/vim-tmux-navigator'
    })
end)

now(function()
    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = {'nvim-lua/plenary.nvim'},
        checkout = '0.1.8'

    })
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep live" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp tags" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    vim.keymap.set("n", "<leader>fr", builtin.grep_string, { desc = "[F]ind [R]ef under cursor" })
    vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "[F]ind [I]ncoming calls" })
    vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, { desc = "[F]ind [O]utgoing calls" })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "[F]ind [S]ymbols" })
    vim.keymap.set("n", "<leader>fR", builtin.resume, { desc = "[F]indings [R]esume" })
    vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })

    -- Extensions

    -- Custom function to have lazy:'build' or vimplug:'do' equivalent
    -- It takes param that are passed to 'hooks' (cf mini.deps doc)
    local function make_fzf_native(params)
        vim.cmd("lcd " .. params.path)
        vim.cmd("!make -s")
        -- vim.cmd("cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release")
        vim.cmd("lcd -")
    end
	add({
        source = "nvim-telescope/telescope-fzf-native.nvim",
        hooks = {
            post_install = make_fzf_native,
            post_checkout = make_fzf_native
        },
    })
    require("telescope").load_extension("fzf")

	add({
		source = "nvim-telescope/telescope-ui-select.nvim",
	})
    require("telescope").load_extension("ui-select")
end)

later(function()
    add({
        source = 'cameron-wags/rainbow_csv.nvim',
        name = 'rainbow_csv'
    })
    local rainbow_csv = require('rainbow_csv')
    rainbow_csv.config = true,
    -- rainbow_csv.ft = {
    --     'csv',
    --     'tsv',
    --     'csv_semicolon',
    --     'csv_whitespace',
    --     'csv_pipe',
    --     'rfc_csv',
    --     'rfc_semicolon'
    -- },
    -- rainbow_csv.cmd = {
    --     'RainbowDelim',
    --     'RainbowDelimSimple',
    --     'RainbowDelimQuoted',
    --     'RainbowMultiDelim'
    -- }
    rainbow_csv.setup()
end)

now(function()

    --- @param trunc_width number trunctates component when screen width is less than trunc_width
    --- @param trunc_len number truncates component to trunc_len number of chars
    --- @param hide_width number hides component when window width is smaller than hide_width
    --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
    --- @param always_trunc boolean whether to truncate regardless of window width
    --- return function that can format the component accordingly
    local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis, always_trunc)
        return function(str)
            local win_width = vim.fn.winwidth(0)
            if hide_width and win_width < hide_width then
                return ""
            elseif always_trunc then
                return str:sub(1, trunc_len) .. (string.len(str) < trunc_len and "" or "...")
            elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
                return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
            end
            return str
        end
    end

    add({
        source = "nvim-lualine/lualine.nvim",
    })
    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { "branch", fmt = trunc(80, 21, 10, false, true) },
                "diff",
                "diagnostics",
            },
            lualine_c = {
                {
                    "buffers",
                    show_filename_only = true, -- Shows shortened relative path when set to false.
                    hide_filename_extension = true, -- Hide filename extension when set to true.
                    show_modified_status = true, -- Shows indicator when the buffer is modified.
                    mode = 0, -- 0: Shows buffer name
                    -- 1: Shows buffer index
                    -- 2: Shows buffer name + buffer index
                    -- 3: Shows buffer number
                    -- 4: Shows buffer name + buffer number
                    max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                    -- it can also be a function that returns
                    -- the value of `max_length` dynamically.
                    filetype_names = {
                        TelescopePrompt = "Telescope",
                        dashboard = "Dashboard",
                        fzf = "FZF",
                    }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                    -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
                    use_mode_colors = false,
                    -- |!\ BUG
                    --buffers_color = {
                        --    -- Same values as the general color option can be used here.
                        --    active = 'lualine_{section}_normal',     -- Color for active buffer.
                        --    inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
                        --},
                        symbols = {
                            modified = " ●", -- Text to show when the buffer is modified
                            alternate_file = "#", -- Text to show to identify the alternate file
                            directory = "", -- Text to show when the buffer is a directory
                        },
                    },
                },
                lualine_d = { "FugitiveHead" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
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

later(function()
    add({
        source = "dhananjaylatkar/cscope_maps.nvim",
        depends = {
            "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
        },
    })
    local opts = {
        -- Take word under cursor as input
        skip_input_prompt = true,
        -- disables default keymaps
        disable_maps = true,

        cscope = {
            exec = "cscope",
            picker = "telescope", -- Then Ctrl-q to send to quickfix (or Resume Telescope last search)
            -- do not open picker for single result, just JUMP
            skip_picker_for_single_result = true,
            -- custom script can be used for db build
            db_build_cmd = { script = "default", args = { "-bqkvR" } },
            -- try to locate db_file in parent dir(s)
            project_rooter = {
                enable = true,
                -- change cwd to where db_file is located
                change_cwd = true,
            },
        },
    },
    require('cscope_maps').setup(opts)

    -- Build cscope.files (required to build database)
    vim.keymap.set("n", "<leader>cl", function()
        local use_fd = os.execute("fd --version > /dev/null 2>&1")
        local cmd
        if use_fd then
            -- List files with fd
            cmd = 'fd -t f -e c -e h > cscope.files'
        else
            -- List files with find
            cmd = 'find . -type f \\( -name "*.c" -o -name "*.h" \\) > cscope.files'
        end

        -- Run the command
        vim.fn.system(cmd)

        -- Notify the user
        print("cscope.files generated")
    end, { desc = "[C]scope [l]ist files for DB gen" })

    -- Use my own keymaps for better muscle memory
    vim.keymap.set("n", "<leader>cs", "<cmd>CsPrompt s<cr>", {desc = "[C]scope Find [s]ymbol"})
    vim.keymap.set("n", "<leader>cd", "<cmd>CsPrompt g<cr>", {desc = "[C]scope GoTo [d]efinition"})
    vim.keymap.set("n", "<leader>cI", "<cmd>CsPrompt c<cr>", {desc = "[C]scope Find Caller ([i]n)"})
    vim.keymap.set("n", "<leader>cO", "<cmd>CsPrompt d<cr>", {desc = "[C]scope Find Callee ([o]ut)"})
    vim.keymap.set("n", "<leader>ct", "<cmd>CsPrompt t<cr>", {desc = "[C]scope Find [t]ext string"})
    vim.keymap.set("n", "<leader>cg", "<cmd>CsPrompt e<cr>", {desc = "[C]scope Find [g]rep pattern"})
    vim.keymap.set("n", "<leader>cf", "<cmd>CsPrompt f<cr>", {desc = "[C]scope Find [f]ile"})
    vim.keymap.set("n", "<leader>ch", "<cmd>CsPrompt i<cr>", {desc = "[C]scope Find #include of this [h]eader"})
    vim.keymap.set("n", "<leader>ca", "<cmd>CsPrompt a<cr>", {desc = "[C]scope Find [a]ssignments"})
    vim.keymap.set("n", "<leader>cb", "<cmd>CsPrompt b<cr>", {desc = "[C]scope [b]uild DB"})

    -- View call-in Stack hierarchy
    vim.keymap.set("n", "<leader>ci", function()
        local func = vim.fn.expand("<cword>")
        local command = ":CsStackView open down " .. func
        vim.cmd(command)
    end, { desc = "[C]scope [i]n stack Call" })

    -- View call-out Stack hierarchy
    vim.keymap.set("n", "<leader>co", function()
        local func = vim.fn.expand("<cword>")
        local command = ":CsStackView open up " .. func
        vim.cmd(command)
    end, { desc = "[C]scope [o]ut stack call" })
end)

later(function()
    add({
        source = 'saecki/crates.nvim'
    })
    require('crates').setup()
end)

later(function()
    add({
		source = "rhysd/conflict-marker.vim",
    })
    vim.keymap.set("n", "<leader>mn", "<cmd>ConflictMarkerNextHunk<cr>", { desc = "[M]erge Conflict [N]ext" })
    vim.keymap.set("n", "<leader>mp", "<cmd>ConflictMarkerPrevHunk<cr>", { desc = "[M]erge Conflict [P]rev" })
end)

later(function()
	add({
        source = "lewis6991/gitsigns.nvim"
    })
    require('gitsigns').setup()
end)

later(function()
	add({
        source = "nvim-treesitter/nvim-treesitter",
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "rust", "bash", "json", "toml", "python" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        -- TODO https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
        -- Automatically install missing parsers when entering buffer (need tree-sitter CLI)
        -- auto_install = true,
    })
end)

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

    -- C/C++ (requires cmake OR bear+Makefile: https://github.com/rizsotto/Bear)
    -- lspconfig.clangd.setup({
    --     capabilities = caps,
    -- })

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
