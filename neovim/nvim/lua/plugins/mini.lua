return {
    {
        -- TODO use min.deps instead of Lazy !
        "echasnovski/mini.nvim",
        config = function()

            -- For nice compatibility in mini
            require("mini.icons").setup()

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

            -- Trailing whitespace
            require("mini.trailspace").setup()

            -- Autocompletion (simpler than nvim-cmp)
            require("mini.completion").setup()

            -- Animations (mostly for shared screen)
            -- require('mini.animate').setup()

            -- Highlight word under cursor
            require('mini.cursorword').setup()

            -- Notifications and LSP progress
            -- TODO vim.notify = require('mini.notify').make_notify()
            require('mini.notify').setup({
            })

            -- File navigation
            require('mini.files').setup()

        end,
    },
 }
