local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Better text objects (this ain't chatgpt!)
later(function() require('mini.ai').setup() end)

-- Allow pretty formatting
later(function() require('mini.align').setup() end)

-- Quick toggle comment
later(function() require('mini.comment').setup() end)

-- Better f, F, t, T
later(function() require('mini.jump').setup() end)

-- Move any selection in any direction (with Alt + hjkl)
later(function() require('mini.move').setup() end)

-- Automatically close brackets & quotes
later(function() require('mini.pairs').setup() end)

-- Split and join arguments
later(function()
    require('mini.splitjoin').setup()
    vim.keymap.set("n", "<leader>sj", ":lua MiniSplitjoin.toggle()<CR>", { desc = "[S]plit/[J]oin" })
end)

-- Easy add surroundings
later(function() require('mini.surround').setup() end)

-- Quickly remove trailing spaces
later(function()
    require('mini.trailspace').setup()
    vim.keymap.set("n", "<leader>st", ":lua MiniTrailspace.trim()<CR>", { desc = "[S]pace/[T]rim" })
end)
