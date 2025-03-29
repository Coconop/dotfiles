local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Visualize current scope
later(function() require('mini.indentscope').setup({
    delay = 0,
    animation = function(n, s) return 0 end
}) end)

-- Visualize occurences on word under cursor
later(function() require('mini.cursorword').setup() end)

-- Highlight known patterns
later(function()
    local minihip = require('mini.hipatterns')
    local grp_conflict_start = minihip.compute_hex_color_group("#f38ba8", 'bg')
    local grp_conflict_mid = minihip.compute_hex_color_group("#cba6f7", 'bg')
    local grp_conflict_end = minihip.compute_hex_color_group("#f9e2af", 'bg')

    require('mini.hipatterns').setup({
        highlighters = {
            fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },

            git_conflict_start = { pattern = '^<<<<<<< .*$', group = grp_conflict_start },
            git_conflict_middle = { pattern = '^=======$', group = grp_conflict_mid },
            git_conflict_end = { pattern = '^>>>>>>> .*$', group = grp_conflict_end },
            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },})
end)


-- Code completion engine
later(function() require('mini.completion').setup() end)

-- Good old cscope (got your back when there is no clang LSP)
later(function()
    add({
        source = "dhananjaylatkar/cscope_maps.nvim",
        depends = {
            "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
        },
    })
    require('cscope_maps').setup({
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
        source = "nvim-treesitter/nvim-treesitter",
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "rust", "bash", "json", "toml", "python", "groovy" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        -- TODO https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
        -- Automatically install missing parsers when entering buffer (need tree-sitter CLI)
        -- auto_install = true,
    })
end)
