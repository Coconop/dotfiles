local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Better text objects (this ain't chatgpt!)
later(function() require('mini.ai').setup() end)

-- Better f, F, t, T
later(function() require('mini.jump').setup() end)

-- Automatically close brackets & quotes
later(function() require('mini.pairs').setup() end)

-- Easy add surroundings
later(function() require('mini.surround').setup() end)

-- Quickly remove trailing spaces
later(function()
    require('mini.trailspace').setup()
    vim.keymap.set("n", "<leader>st", ":lua MiniTrailspace.trim()<CR>", { desc = "[S]pace/[T]rim" })
end)

-- Detect and adapt indent style (shiftwidth and expandtab)
now(function()
    add({
		source = "tpope/vim-sleuth",
    })
end)
