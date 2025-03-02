local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- See latest crates versions, available features, etc.
later(function()
    add({
        source = 'saecki/crates.nvim'
    })
    require('crates').setup()
end)

-- Nice CSV viewer
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
