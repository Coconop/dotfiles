require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '|', right = '|'},
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
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            {
                'buffers',
                show_filename_only = true,   -- Shows shortened relative path when set to false.
                hide_filename_extension = true,   -- Hide filename extension when set to true.
                show_modified_status = true, -- Shows indicator when the buffer is modified.

                mode = 4, -- 0: Shows buffer name
                -- 1: Shows buffer index
                -- 2: Shows buffer name + buffer index
                -- 3: Shows buffer number
                -- 4: Shows buffer name + buffer number

                max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                -- it can also be a function that returns
                -- the value of `max_length` dynamically.
                filetype_names = {
                    TelescopePrompt = 'Telescope',
                    dashboard = 'Dashboard',
                    fzf = 'FZF',
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
                    modified = ' ●',      -- Text to show when the buffer is modified
                    alternate_file = '#', -- Text to show to identify the alternate file
                    directory =  '',     -- Text to show when the buffer is a directory
                },
            },
        },
        lualine_d = {'FugitiveHead'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
