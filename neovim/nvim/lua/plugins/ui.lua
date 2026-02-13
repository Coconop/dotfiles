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

now(function()
    require('mini.statusline').setup()
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
        source = 'EdenEast/nightfox.nvim',
    })
    vim.cmd([[colorscheme nordfox]])
end)

