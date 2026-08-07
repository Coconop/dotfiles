-- Optimize loading of lua modules (parse and compile once then use cache)
vim.loader.enable()

-- Use this with :startuptime to optimize
-- vim.g.startup_profile = true

-- General Neovim settings
require("config.options")
-- Neovim keybindings
require("config.keymaps")
-- Custom autocommands
require("config.autocmd")
-- Plugin replacement
require("noplugin")

-- To remove a plugin
-- `:lua vim.pack.update()` to get the list -> spot `not active`
-- `:lua vim.pack.del({'plug1.nvim', 'plug2-nvim'})`
vim.pack.add({
    -- Dependencies:
    -- None \o/

    -- Fuzzy-finder picker
    'https://github.com/ibhagwan/fzf-lua',
    -- Library of minimalistics and independants lua modules
    'https://github.com/nvim-mini/mini.nvim',
    -- Tmux integration for easy windows navigation
    'https://github.com/christoomey/vim-tmux-navigator',
    -- [c] Integration of good old cscope (fallback if no LSP)
    'https://github.com/dhananjaylatkar/cscope_maps.nvim',
    -- [md] Markdown table editor
    'https://github.com/SCJangra/table-nvim',
    -- [rust] Easy management of crates
    'https://github.com/saecki/crates.nvim',
    -- [csv] Pretty csv viewer
    'https://github.com/cameron-wags/rainbow_csv.nvim',
    -- Colorscheme collection
    'https://github.com/EdenEast/nightfox.nvim', -- nordfox <3
    'https://github.com/neanias/everforest-nvim',

    ---- Testing
    'https://github.com/CoreyKaylor/diffbandit.nvim',

    -- nvim-treesitter is archived but nvim 0.12+ has native treesitter hl
    -- If language is not present, use tree-sitter-cli (cargo)
    -- and `:TSInstall <lang>`
})

------ Mini -------------------------------------------------------------------

-- Pretty icons lib for UI
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
-- Better text objects (this ain't chatgpt!)
require('mini.ai').setup()
-- Automatically close brackets & quotes
require('mini.pairs').setup()
-- Easy add surroundings (saiw, sr, sd)
require('mini.surround').setup()
-- Code completion engine
require('mini.completion').setup()
-- Visualize occurences on word under cursor
require('mini.cursorword').setup()
-- Simple status line
require('mini.statusline').setup()
-- Code/text easy alignment (ga or gA for preview)
require('mini.align').setup()
-- Split (gS) or Join (gJ) arguments
require('mini.splitjoin').setup()

-- Visualize current scope
require('mini.indentscope').setup({
    delay = 0,
    animation = function(n, s) return 0 end
})

-- Highlight known patterns
local minihip = require('mini.hipatterns')
local grp_conflict_start = minihip.compute_hex_color_group("#f38ba8", 'bg')
local grp_conflict_mid   = minihip.compute_hex_color_group("#cba6f7", 'bg')
local grp_conflict_end   = minihip.compute_hex_color_group("#f9e2af", 'bg')
require('mini.hipatterns').setup({
    highlighters = {
        fixme = {
            pattern = '%f[%w]()FIXME()%f[%W]',
            group = 'MiniHipatternsFixme' },
        todo  = {
            pattern = '%f[%w]()TODO()%f[%W]',
            group = 'MiniHipatternsTodo'
        },

        git_conflict_start = {
            pattern = '^<<<<<<< .*$',
            group = grp_conflict_start
        },
        git_conflict_middle = {
            pattern = '^=======$',
            group = grp_conflict_mid
        },
        git_conflict_end = {
            pattern = '^>>>>>>> .*$',
            group = grp_conflict_end
        },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },})

-- Visualize diff hunks (not git-related)
require('mini.diff').setup({
    view = {
        style = 'sign',
        signs = { add='+', change='~', delete='-'}
    }
})
vim.keymap.set(
    "n",
    "<leader>md",
    ":lua MiniDiff.toggle_overlay()<CR>",
    { desc = "[M]ini [D]iff" }
)

-- Pretty notifications
local level_icons = {
    ERROR = '󰅚',
    WARN  = '󰀪',
    INFO  = '󰋽',
    DEBUG = '',
    TRACE = '✎',
}
require('mini.notify').setup({
    content = {
        format = function(notif)
            -- use custom icons
            local icon = level_icons[notif.level] or '(i)'
            -- remove trailing CR/LF (usually from external tools)
            local msg = notif.msg:gsub("[\r\n]+$", "")
            return string.format('%s %s', icon, msg)
        end,
        -- Show more recent notifications first
        sort = function(notif_arr)
            table.sort(
                notif_arr,
                function(a, b) return a.ts_update > b.ts_update end
            )
            return notif_arr
        end,
    },
    window = {
        winblend = 0,
        -- wider than the 0.382 default
        max_width_share = 0.5,
        config = function()
            return { border = 'rounded' }
        end,
    },
})
-- Colorize custom notifications
vim.notify = require('mini.notify').make_notify(
  {
    ERROR = { duration = 5000, hl_group = 'DiagnosticError'  },
    WARN  = { duration = 5000, hl_group = 'DiagnosticWarn'   },
    INFO  = { duration = 5000, hl_group = 'DiagnosticInfo'   },
    DEBUG = { duration = 5000, hl_group = 'DiagnosticHint'   },
    TRACE = { duration = 5000, hl_group = 'DiagnosticOk'     },
    OFF   = { duration = 5000, hl_group = 'MiniNotifyNormal' },
  }
)
vim.keymap.set("n",
    "<leader>ns",
    ":lua require('mini.notify').show_history()<CR>",
    { desc = "[N]otifications [S]how" })

-- Keep windows layout when closing a buffer
require('mini.bufremove').setup()
vim.keymap.set(
    "n",
    "<leader>bd",
    ":lua require('mini.bufremove').unshow()<CR>",
    { desc = "[B]uffer [D]elete" }
)


-- Help remember my keybindings
require('mini.clue').setup({
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
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
    },

    window = {
        -- Show window immediately
        delay = 250,

        config = {
            -- Compute window width automatically
            width = 50,
        },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers({
            show_contents = true
        }),
        require('mini.clue').gen_clues.windows({
            submode_move = true,
            submode_navigate = true,
            submode_resize = true,
        }),
        require('mini.clue').gen_clues.z(),
    },
})

------ FZF-LUA--- --------------------------------------------------------------
local fzf = require('fzf-lua')
-- fzf.setup()
vim.keymap.set(
    "n", "<leader>ff", fzf.files,         { desc="[F]ind [F]iles" })
vim.keymap.set(
    "n", "<leader>fg", fzf.live_grep,     { desc="[F]ind [G]rep live" })
vim.keymap.set(
    "n", "<leader>fb", fzf.buffers,       { desc="[F]ind [B]uffers" })
vim.keymap.set(
    "n", "<leader>fh", fzf.helptags,      { desc="[F]ind [H]elp tags" })
vim.keymap.set(
    "n", "<leader>fr", fzf.grep_cword,    { desc="[F]ind [R]ef under cursor" })
vim.keymap.set(
    "n", "<leader>fR", fzf.resume,        { desc="[F]indings [R]esume" })
vim.keymap.set(
    "n", "<leader>fp", fzf.complete_path, { desc="Complete [F]uzzy [P]ath" })
vim.keymap.set(
    "n", "<leader>fm", fzf.marks,         { desc="[F]indings [M]arks" })
vim.keymap.set(
    "n", "<leader>fn",
    function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
    end,
    { desc = "[F]ind [N]eovim files" }
)

------ cscope_maps -------------------------------------------------------------
require('cscope_maps').setup({
    -- Take word under cursor as input
    skip_input_prompt = true,
    -- disables default keymaps
    disable_maps = true,

    cscope = {
        exec = "cscope",
        picker = "fzf-lua", -- Then Ctrl-q to send to quickfix
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
})

-- Build cscope.files (required to build database)
vim.keymap.set("n", "<leader>cl", function()
    local use_fd = vim.fn.system("fd --version > /dev/null 2>&1") == 0
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
    vim.notify("cscope.files generated")
end, { desc = "[C]scope [l]ist files for DB gen" })

-- Use my own keymaps for better muscle memory
vim.keymap.set("n", "<leader>cs", "<cmd>CsPrompt s<cr>",
    {desc = "[C]scope Find [s]ymbol"})
vim.keymap.set("n", "<leader>cd", "<cmd>CsPrompt g<cr>",
    {desc = "[C]scope GoTo [d]efinition"})
vim.keymap.set("n", "<leader>cI", "<cmd>CsPrompt c<cr>",
    {desc = "[C]scope Find Caller ([i]n)"})
vim.keymap.set("n", "<leader>cO", "<cmd>CsPrompt d<cr>",
    {desc = "[C]scope Find Callee ([o]ut)"})
vim.keymap.set("n", "<leader>ct", "<cmd>CsPrompt t<cr>",
    {desc = "[C]scope Find [t]ext string"})
vim.keymap.set("n", "<leader>cg", "<cmd>CsPrompt e<cr>",
    {desc = "[C]scope Find [g]rep pattern"})
vim.keymap.set("n", "<leader>cf", "<cmd>CsPrompt f<cr>",
    {desc = "[C]scope Find [f]ile"})
vim.keymap.set("n", "<leader>ch", "<cmd>CsPrompt i<cr>",
    {desc = "[C]scope Find #include of this [h]eader"})
vim.keymap.set("n", "<leader>ca", "<cmd>CsPrompt a<cr>",
    {desc = "[C]scope Find [a]ssignments"})

vim.keymap.set("n", "<leader>cb", function()
    vim.notify("Building cscope database...", vim.log.levels.INFO)
    vim.system({'cscope', '-bqkvR'}, {}, function(result)
        if result.code == 0 then
            vim.notify("Cscope database built successfully")
        else
            vim.notify(
                "Cscope build failed: " .. (result.stderr or ""),
                vim.log.levels.ERROR)
        end
    end)
end, {desc = "[C]scope [b]uild DB"})

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

--------- Colorschemes ---------------------------------------------------------
vim.cmd("colorscheme everforest")

-- LSP -------------------------------------------------------------------------

-- Always let space for diagnostics, signs, etc
vim.opt.signcolumn = "yes"

-- Setup keymaps etc ONLY if there is an attached LSP
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",

    callback = function(event)

        vim.keymap.set("n", "<leader>ld", function()
            require("fzf-lua").lsp_definitions()
        end, {buffer = event.buf, desc = "[L]SP goto [d]efinition" })

        vim.keymap.set("n", "<leader>lD", function()
            vim.lsp.buf.declaration()
        end, {buffer = event.buf, desc = "[L]SP goto [D]eclaration" })

        vim.keymap.set("n", "<leader>lr", function()
            require("fzf-lua").lsp_references()
        end, {buffer = event.buf, desc = "[L]SP [r]eferences" })

        vim.keymap.set("n", "<leader>lI", function()
            require("fzf-lua").lsp_implementations()
        end, {buffer = event.buf, desc = "[L]SP [I]mplementations" })

        vim.keymap.set("n", "<leader>lR", function()
            vim.lsp.buf.rename()
        end, {buffer = event.buf, desc = "[L]SP [R]ename" })

        vim.keymap.set("n", "<leader>la", function()
            vim.lsp.buf.code_action()
        end, {buffer = event.buf, desc = "[L]SP code [A]ction" })

        vim.keymap.set("n", "<leader>lci", function()
            require("fzf-lua").lsp_incoming_calls()
        end, {buffer = event.buf, desc = "[L]SP [C]allstack [I]ncoming" })

        vim.keymap.set("n", "<leader>lco", function()
            require("fzf-lua").lsp_outgoing_calls()
        end, {buffer = event.buf, desc = "[L]SP [C]allstack [O]utgoing" })

        vim.keymap.set("n", "<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            vim.notify(
                vim.lsp.inlay_hint.is_enabled()
                    and "Inlay Hints Enabled" or "Inlay Hints Disabled",
                vim.log.levels.DEBUG)
        end, {buffer = event.buf, desc = "[L]SP inlay [H]ints toggle" })

    end
})

-- Diagnostics -----------------------------------------------------------------

vim.keymap.set("n", "<leader>dt", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    vim.notify(vim.diagnostic.is_enabled()
        and "Diagnostics Enabled" or "Diagnostics Disabled",
        vim.log.levels.DEBUG)
end, { desc = "[D]iagnostic [T]oggle" })

-- navigate diagnostics
vim.keymap.set("n", "<leader>dn", function()
    vim.diagnostic.jump({count=1, float=true}) end,
    {desc = "[D]iagnostic [N]ext "})
vim.keymap.set("n", "<leader>dp", function()
    vim.diagnostic.jump({count=-1, float=true}) end,
    {desc = "[D]iagnostic [P]rev"})
vim.keymap.set("n", "<leader>dl", function()
    require("fzf-lua").diagnostics_document()
end, { desc = "[D]iagnostic [L]ist" })

-- UI render
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        },
        -- Highlight entire line for errors
        linehl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        },
        -- Highlight the line number for warnings
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
        },
    },
    -- No distraction by default
    virtual_text = false,
    virtual_lines = false,
    underline = true,
})

vim.keymap.set({ "n", "x" }, "<leader>dvt", function()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current })
    vim.notify("virtual_text: " .. tostring(not current), vim.log.levels.DEBUG)
end, {desc = "[D]iagnostic [V]irtual [T]ext toogle"})

vim.keymap.set({ "n", "x" }, "<leader>dvl", function()
    local current = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = not current })
    vim.notify("virtual_lines: " .. tostring(not current), vim.log.levels.DEBUG)
end, {desc = "[D]iagnostic [V]irtual [L]ines toogle"})

vim.keymap.set({ "n", "x" }, "<leader>du", function()
    local current = vim.diagnostic.config().underline
    vim.diagnostic.config({ underline = not current })
    vim.notify("underline: " .. tostring(not current), vim.log.levels.DEBUG)
end, {desc = "[D]iagnostic [U]nderline toogle"})


-- Clear all diagnostics
vim.keymap.set("n", "<leader>dc", function()
    vim.diagnostic.reset()
end, { desc = "[D]iagnostic [C]lear ALL"})


--- Lsp toogle (disabled by default for fast edit) -----------------------------

-- groovyls is disabled for current workflow but lsp/groovyls exists

vim.keymap.set("n", "<leader>lg", function()
    vim.notify("Enabling LSP")
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('clangd')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('pyright')
    -- vim.lsp.enable('groovyls')
end, { desc = "[L]SP [g]o"})

vim.keymap.set("n", "<leader>lx", function()
    vim.notify("Disabling LSP")
    for _, client in ipairs(vim.lsp.get_clients()) do
        client:stop()
    end
    vim.lsp.enable('rust_analyzer', false)
    vim.lsp.enable('clangd', false)
    vim.lsp.enable('lua_ls', false)
    vim.lsp.enable('pyright', false)
    -- vim.lsp.enable('groovyls', false)
end, { desc = "[L]SP e[x]it"})

--- csv ------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function() require("rainbow_csv").setup({}) end,
})

--- Markdown -------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function() require("table-nvim").setup({}) end,
})

--- Rust -----------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "Cargo.toml",
  callback = function() require("crates").setup({}) end,
})

--- Diff -----------------------------------------------------------------------
require("diffbandit").setup()

--- Tweaks ---------------------------------------------------------------------
--- Fix shell commands for Windows
if vim.fn.has('win32') == 1 then
    if vim.fn.executable('bash') == 1 then
        -- Git bash
        vim.o.shell = 'bash' -- 'C:/Program Files/Git/bin/bash.exe'
        vim.o.shellcmdflag = '-c'
        vim.o.shellxquote = '' -- clears the cmd.exe-style quoting that breaks bash
        vim.o.shellquote = ''
        vim.o.shellredir = '>%s 2>&1'
        vim.o.shellpipe = '2>&1 | tee'
        vim.o.shellslash = true -- optional: makes Neovim use / instead of \ internally
    -- else: executable is cmd.exe
    end
end
