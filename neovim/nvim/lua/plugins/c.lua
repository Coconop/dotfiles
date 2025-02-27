return {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
    },
    opts = {
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
    end, { desc = "[C]scope [l]ist files for DB gen" }),

    -- Use my own keymaps for better muscle memory
    vim.keymap.set("n", "<leader>cs", "<cmd>CsPrompt s<cr>", {desc = "[C]scope Find [s]ymbol"}),
    vim.keymap.set("n", "<leader>cd", "<cmd>CsPrompt g<cr>", {desc = "[C]scope GoTo [d]efinition"}),
    vim.keymap.set("n", "<leader>cI", "<cmd>CsPrompt c<cr>", {desc = "[C]scope Find Caller ([i]n)"}),
    vim.keymap.set("n", "<leader>cO", "<cmd>CsPrompt d<cr>", {desc = "[C]scope Find Callee ([o]ut)"}),
    vim.keymap.set("n", "<leader>ct", "<cmd>CsPrompt t<cr>", {desc = "[C]scope Find [t]ext string"}),
    vim.keymap.set("n", "<leader>cg", "<cmd>CsPrompt e<cr>", {desc = "[C]scope Find [g]rep pattern"}),
    vim.keymap.set("n", "<leader>cf", "<cmd>CsPrompt f<cr>", {desc = "[C]scope Find [f]ile"}),
    vim.keymap.set("n", "<leader>ch", "<cmd>CsPrompt i<cr>", {desc = "[C]scope Find #include of this [h]eader"}),
    vim.keymap.set("n", "<leader>ca", "<cmd>CsPrompt a<cr>", {desc = "[C]scope Find [a]ssignments"}),
    vim.keymap.set("n", "<leader>cb", "<cmd>CsPrompt b<cr>", {desc = "[C]scope [b]uild DB"}),

    -- View call-in Stack hierarchy
    vim.keymap.set("n", "<leader>ci", function()
        local func = vim.fn.expand("<cword>")
        local command = ":CsStackView open down " .. func
        vim.cmd(command)
    end, { desc = "[C]scope [i]n stack Call" }),

    -- View call-out Stack hierarchy
    vim.keymap.set("n", "<leader>co", function()
        local func = vim.fn.expand("<cword>")
        local command = ":CsStackView open up " .. func
        vim.cmd(command)
    end, { desc = "[C]scope [o]ut stack call" }),

}
