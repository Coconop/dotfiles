local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Pretty notifications
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
  vim.keymap.set("n", "<leader>vn", ":lua require('mini.notify').show_history()<CR>", { desc = "[V]iew [N]otifications" })
end)

-- Basic icons
now(function()
    require('mini.icons').setup()
    require('mini.icons').mock_nvim_web_devicons()
end)

-- Keep windows layout when closing a buffer
now(function()
    require('mini.bufremove').setup()
    vim.keymap.set("n", "<leader>bd", ":lua require('mini.bufremove').unshow()<CR>", { desc = "[B]uffer [D]elete" })
end)

-- Awesome status line
now(function()
    --- @param trunc_width number trunctates component when screen width is less than trunc_width
    --- @param trunc_len number truncates component to trunc_len number of chars
    --- @param hide_width number hides component when window width is smaller than hide_width
    --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
    --- @param always_trunc boolean whether to truncate regardless of window width
    --- return function that can format the component accordingly
    local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis, always_trunc)
        return function(str)
            local win_width = vim.fn.winwidth(0)
            if hide_width and win_width < hide_width then
                return ""
            elseif always_trunc then
                return str:sub(1, trunc_len) .. (string.len(str) < trunc_len and "" or "...")
            elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
                return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
            end
            return str
        end
    end

    add({
        source = "nvim-lualine/lualine.nvim",
    })
    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
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
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { "branch", fmt = trunc(80, 21, 10, false, true) },
                "diff",
                "diagnostics",
            },
            lualine_c = {
                {
                    "buffers",
                    show_filename_only = true, -- Shows shortened relative path when set to false.
                    hide_filename_extension = true, -- Hide filename extension when set to true.
                    show_modified_status = true, -- Shows indicator when the buffer is modified.
                    mode = 0, -- 0: Shows buffer name
                    -- 1: Shows buffer index
                    -- 2: Shows buffer name + buffer index
                    -- 3: Shows buffer number
                    -- 4: Shows buffer name + buffer number
                    max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                    -- it can also be a function that returns
                    -- the value of `max_length` dynamically.
                    filetype_names = {
                        TelescopePrompt = "Telescope",
                        dashboard = "Dashboard",
                        fzf = "FZF",
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
                            modified = " ●", -- Text to show when the buffer is modified
                            alternate_file = "#", -- Text to show to identify the alternate file
                            directory = "", -- Text to show when the buffer is a directory
                        },
                    },
                },
                lualine_d = { "FugitiveHead" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
end)

-- Help remember my keybindings
now(function() require('mini.clue').setup({
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
}) end)

-- Cool colorschemes
now(function()
    add({
        source = 'catppuccin/nvim',
		name = "catppuccin",
    })
    -- vim.cmd([[colorscheme catppuccin-mocha]])
end)

now(function()
    add({
        source = 'sainnhe/everforest',
		name = "everforest",
    })
    -- vim.cmd([[colorscheme everforest]])
end)

now(function()
    add({
        source = 'rebelot/kanagawa.nvim',
		name = "kanagawa",
    })
    require('kanagawa').setup({
        integrations = { telescope = true },
    })
    -- vim.cmd([[colorscheme kanagawa]])
end)

now(function()
    add({
        source = 'EdenEast/nightfox.nvim',
    })
    vim.cmd([[colorscheme nordfox]])
end)

now(function()
    add({
        source = 'gbprod/nord.nvim',
    })
    -- vim.cmd([[colorscheme nord]])
end)
