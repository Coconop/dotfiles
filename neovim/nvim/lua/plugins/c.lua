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
}
