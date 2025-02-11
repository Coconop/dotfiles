return {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {},
    opts = {
        -- Take word under cursor as input
        skip_input_prompt = true,
        -- prefix to trigger maps
        prefix = "<leader>g",
        -- do not open picker for single result, just JUMP
        skip_picker_for_single_result = true,
        -- custom script can be used for db build
        db_build_cmd = { script = "default", args = { "-bqkv" } },
        -- try to locate db_file in parent dir(s)
        project_rooter = {
            enable = true,
            -- change cwd to where db_file is located
            change_cwd = true,
        },
    },
    -- Build cscope.files (required to build database)
    vim.keymap.set("n", "<leader>gl", function()
        -- List files with fd
        local cmd = 'fd -t f -e c -e h > cscope.files'
        -- List files with find
        -- local cmd = 'find . -type f \\( -name "*.c" -o -name "*.h" \\) > cscope.files'

        -- Run the command
        vim.fn.system(cmd)

        -- Notify the user
        print("cscope.files generated")
    end, { desc = "Generate cscope.files list" }),

    -- View callers in picker
    vim.keymap.set("n", "<leader>gvi", function()
        local func = vim.fn.expand("<cword>")
        local command = ":CsStackView open down " .. func
        vim.cmd(command)
    end, { desc = "View callers in picker" }),

    -- View callee in picker
    vim.keymap.set("n", "<leader>gvo", function()
        local func = vim.fn.expand("<cword>")
        local command = ":CsStackView open up " .. func
        vim.cmd(command)
    end, { desc = "View callees in picker" }),
}
