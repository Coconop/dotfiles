return {
    {
        "echasnovski/mini.nvim",
        config = function()
            -- Extend and create a/i textobjects
            require("mini.ai").setup({ n_lines = 500 })
            -- Fast and feature-rich surround actions
            require("mini.surround").setup()
            -- Align/Justify/Merge
            require("mini.align").setup()
            -- Handy comments
            require("mini.comment").setup()
            -- Visualize current scope TODO: custom jumps cmds
            require("mini.indentscope").setup({
                delay = 0,
                animation = function(n, s) return 0 end
            })
            -- auto-pair
            require("mini.pairs").setup()
            -- Highlight text patterns
            require("mini.hipatterns").setup({
                highlighters = {
                    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
                },
            })
        end,
    },
 }
