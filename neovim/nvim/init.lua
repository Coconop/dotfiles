-- Optimize loading of lua modules (parse and compile once then use cache)
vim.loader.enable()

-- General Neovim settings
require("config.options")
-- Neovim keybindings
require("config.keymaps")
-- Custom autocommands
require("config.autocmd")

-- Catch Pack events to define hooks via autocommands
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
    -- Retrieve which plugin triggered on which event
    local name, kind = ev.data.spec.name, ev.data.kind

    -- When Treesitter is upgraded, installed parser shall also be updated
    if name == 'nvim-treesitter' and kind == 'update' then
        -- If plugin is not loaded yet, do it before using its command
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        -- Update installed parsers
        vim.cmd('TSUpdate')
    end
end })

vim.pack.add({
    -- Lua utilities for Neovim used by other plugins as dependency
    'https://github.com/nvim-lua/plenary.nvim',
    -- Fuzzy-finder picker
    'https://github.com/ibhagwan/fzf-lua',
    -- Library of minimalistics and independants lua modules
    'https://github.com/nvim-mini/mini.nvim',
    -- Advanced code parser for text-objects handle and syntax highlight
    'https://github.com/nvim-treesitter/nvim-treesitter',
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
    -- [groovy] Jenkins file linter
    'https://github.com/ckipp01/nvim-jenkinsfile-linter',
    -- Colorscheme collection
    'https://github.com/EdenEast/nightfox.nvim',
})

------ Mini -------------------------------------------------------------------

-- Pretty icons lib for UI
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
-- Better text objects (this ain't chatgpt!)
require('mini.ai').setup()
-- Better f, F, t, T
require('mini.jump').setup()
-- Automatically close brackets & quotes
require('mini.pairs').setup()
-- Easy add surroundings
require('mini.surround').setup()
-- Code completion engine
require('mini.completion').setup()
-- Visualize occurences on word under cursor
require('mini.cursorword').setup()
-- Simple status line
require('mini.statusline').setup()

-- Visualize current scope
require('mini.indentscope').setup({
    delay = 0,
    animation = function(n, s) return 0 end
})

-- Highlight known patterns
local minihip = require('mini.hipatterns')
local grp_conflict_start = minihip.compute_hex_color_group("#f38ba8", 'bg')
local grp_conflict_mid = minihip.compute_hex_color_group("#cba6f7", 'bg')
local grp_conflict_end = minihip.compute_hex_color_group("#f9e2af", 'bg')
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
vim.keymap.set("n", "<leader>md", ":lua MiniDiff.toggle_overlay()<CR>", { desc = "[M]ini [D]iff" })

-- Hybrid filetree viewer with oil/vineagar spirit
require('mini.files').setup({
    windows = {
        preview = false,
    }
})
vim.keymap.set("n", "<leader>ee", ":lua MiniFiles.open()<CR>", { desc = "[E]xplorer" })

-- Pretty notifications
require('mini.notify').setup()
vim.notify = require('mini.notify').make_notify()
vim.keymap.set("n", "<leader>vn", ":lua require('mini.notify').show_history()<CR>", { desc = "[V]iew [N]otifications" })

-- Keep windows layout when closing a buffer
require('mini.bufremove').setup()
vim.keymap.set("n", "<leader>bd", ":lua require('mini.bufremove').unshow()<CR>", { desc = "[B]uffer [D]elete" })


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
        -- { mode = 'n', keys = 'z' },
        -- { mode = 'x', keys = 'z' },
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
        require('mini.clue').gen_clues.windows(),
        -- require('mini.clue').gen_clues.z(),
    },
})

------ Treesitter --------------------------------------------------------------
require('fzf-lua').setup()
vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", require("fzf-lua").live_grep, { desc = "[F]ind [G]rep live" })
vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fh", require("fzf-lua").helptags, { desc = "[F]ind [H]elp tags" })
vim.keymap.set("n", "<leader>fr", require("fzf-lua").grep_cword, { desc = "[F]ind [R]ef under cursor" })
vim.keymap.set("n", "<leader>fR", require("fzf-lua").resume, { desc = "[F]indings [R]esume" })
vim.keymap.set("n", "<leader>fp", require("fzf-lua").complete_path, { desc = "Complete [F]uzzy [P]ath" })
vim.keymap.set("n", "<leader>fn", function()
    require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[F]ind [N]eovim files" })
vim.keymap.set("n", "<leader>fm", require("fzf-lua").marks, { desc = "[F]indings [M]arks" })

------ Treesitter --------------------------------------------------------------
require('nvim-treesitter').setup({
    ensure_installed = { 
        "c", "cpp", "lua", "vim", "vimdoc", "rust", "bash", "json", "toml", 
        "python"},
    highlight = {enable = true},
    indent = {enable = true},
})

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
    vim.notify("Building cscope database...")
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
require('nightfox').setup({
  options = {
    styles = {
      comments = "italic",
    }
  }
})
vim.cmd("colorscheme nordfox")

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
                    and "Inlay Hints Enabled" or "Inlay Hints Disabled")
        end, {buffer = event.buf, desc = "[L]SP inlay [H]ints toggle" })

    end
})

-- Diagnostics -----------------------------------------------------------------

vim.keymap.set("n", "<leader>dt", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    vim.notify(vim.diagnostic.is_enabled()
        and "Diagnostics Enabled" or "Diagnostics Disabled")
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


-- Clear all diagnostics
vim.keymap.set("n", "<leader>dc", function()
    vim.diagnostic.reset()
end, { desc = "[D]iagnostic [C]lear ALL"})


--- Lsp toogle (disabled by default for fast edit) -----------------------------

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
        client.stop()
    end
    vim.lsp.enable('rust_analyzer', false)
    vim.lsp.enable('clangd', false)
    vim.lsp.enable('lua_ls', false)
    vim.lsp.enable('pyright', false)
    -- vim.lsp.enable('groovyls', false)
end, { desc = "[L]SP e[x]it"})

--- Linters --------------------------------------------------------------------

--- ShellCheck
vim.keymap.set("n", "<leader>lts", function()
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
                    severity = 
                            item.level == "error" 
                            and vim.diagnostic.severity.ERROR
                        or
                            item.level == "warning"
                            and vim.diagnostic.severity.WARN
                        or 
                            vim.diagnostic.severity.INFO,
                    message = item.message,
                    source = "shellcheck",
                })
            end

            vim.diagnostic.reset(
                vim.api.nvim_get_namespaces()["shellcheck"], bufnr)
            vim.diagnostic.set(
                vim.api.nvim_create_namespace("shellcheck"), bufnr, diagnostics)
            vim.diagnostic.enable(true)
            vim.diagnostic.config({ virtual_text = false })
            vim.diagnostic.config({ virtual_lines = true })
            vim.diagnostic.jump({count=1, float=true})
        end,
    })
end, { desc = "Lint: [S]hellCheck"})

--- CodeNarc
local function parse_codenarc(output)
    local diagnostics = {}
    local current_file = nil

    -- P1=Error, P2=Warning, P3=Info
    local severity_map = {
        ["1"] = vim.diagnostic.severity.ERROR,
        ["2"] = vim.diagnostic.severity.WARN,
        ["3"] = vim.diagnostic.severity.INFO,
    }

    for line in output:gmatch("[^\r\n]+") do
        -- Match file line
        local file = line:match("^File: (.+)$")
        if file then
            -- Normalize path separators
            current_file = file:gsub("\\", "/")

        -- Match violation line
        elseif current_file then
            local rule, priority, lnum, msg =
            line:match("Violation: Rule=(%S+) P=(%d) Line=(%d+) Msg=%[(.-)%]")
            if rule and priority and lnum and msg then
                table.insert(diagnostics, {
                    file = current_file,
                    lnum = tonumber(lnum) - 1,  -- Neovim is 0-indexed
                    col = 0,
                    severity = 
                        severity_map[priority] or vim.diagnostic.severity.WARN,
                    message = string.format("[%s] %s", rule, msg),
                    source = "codenarc",
                })
            end
        end
    end

    return diagnostics
end

local function set_diagnostics(output)
    local ns = vim.api.nvim_create_namespace("codenarc")
    local diagnostics_by_buf = {}

    for _, d in ipairs(parse_codenarc(output)) do
        -- Find buffer by filename match
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local buf_name = vim.api.nvim_buf_get_name(buf):gsub("\\", "/")
            if buf_name:find(d.file, 1, true) then
                diagnostics_by_buf[buf] = diagnostics_by_buf[buf] or {}
                local line_content = 
                    vim.api.nvim_buf_get_lines(
                        buf, d.lnum, d.lnum + 1, false)[1] or ""
                -- find first non-space, convert to 0-indexed
                local col = line_content:find("%S") - 1  
                table.insert(diagnostics_by_buf[buf], {
                    lnum     = d.lnum,
                    col      = col,
                    severity = d.severity,
                    message  = d.message,
                    source   = d.source,
                })
                break
            end
        end
    end

    -- Clear old diagnostics and set new ones
    for buf, diags in pairs(diagnostics_by_buf) do
        vim.diagnostic.reset(ns, buf)
        vim.diagnostic.set(ns, buf, diags)
    end
end

vim.keymap.set("n", "<leader>ltc", function()
    local codenarc_dir = vim.fs.joinpath(vim.fn.expand("~"), "git", "codenarc")
    local jar = vim.fs.joinpath(codenarc_dir, "CodeNarc-3.7.0.jar")
    local deps_groovy = vim.fs.joinpath(codenarc_dir, "groovy", "*")
    local deps_slf4j = vim.fs.joinpath(codenarc_dir, "slf4j", "*")
    local deps_gmetrics =vim.fs.joinpath(codenarc_dir, "gmetrics", "*")
    -- \ on windows, / on unix
    local sep = package.config:sub(1,1) == "\\" and ";" or ":" 
    local classpath = table.concat(
        {deps_groovy, deps_gmetrics, deps_slf4j, jar},
        sep)

    local codenarc_cmd = {
        "java",
        "-classpath",
        classpath,
        "org.codenarc.CodeNarc",
        "-rulesetfiles=" ..
            "rulesets/basic.xml" ..
            ",rulesets/groovyism.xml" ..
            ",rulesets/jenkins.xml",
        "-sourcefiles=" .. vim.api.nvim_buf_get_name(0),
        "-report=console",
    }

    vim.notify("CodeNarc Linting...")
    local output_lines = {}
    vim.fn.jobstart(codenarc_cmd, {
        on_stdout = function(_, data)
            -- Stream stdout because it is slow
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.notify(line)
                    table.insert(output_lines, line)
                end
            end
        end,
        on_stderr = function(_, data)
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.notify(line, vim.log.levels.WARN)
                end
            end
        end,
        on_exit = function(_, code)
            if code ~= 0 then
                vim.notify("CodeNarc exited with code: " .. 
                    code, vim.log.levels.ERROR)
            end
            -- send accumulated output to process
            set_diagnostics(table.concat(output_lines, "\n"))
        end,
    })

    vim.diagnostic.enable(true)
    vim.diagnostic.config({ virtual_text = false })
    vim.diagnostic.config({ virtual_lines = true })
    vim.diagnostic.jump({count=1, float=true})

end, { desc = "Lint: [C]odeNarc"})

-- Jenkins
vim.keymap.set('n', '<leader>ltj', function()
    vim.diagnostic.enable(true)
    vim.diagnostic.config({ virtual_text = false })
    vim.diagnostic.config({ virtual_line = true })
    require('jenkinsfile_linter').validate()
    vim.diagnostic.jump({count=1, float=true})
end, { desc = "Lint: [J]enkins" })

