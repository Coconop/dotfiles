local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Better text objects (this ain't chatgpt!)
later(function() require('mini.ai').setup() end)

-- Allow pretty formatting
later(function() require('mini.align').setup() end)

-- Quick toggle comment
later(function() require('mini.comment').setup() end)

-- Automatically close brackets & quotes
later(function() require('mini.pairs').setup() end)

-- Easy add surroundings
later(function() require('mini.surround').setup() end)

-- Quickly remove trailing spaces
later(function() require('mini.trailspace').setup() end)
