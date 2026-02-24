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
vim.keymap.set("n", "<leader>st", function()
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
end, { desc = "[S]pace/[T]rim" })

-- Detect and adapt indent style (shiftwidth and expandtab)
now(function()
    add({
	source = "tpope/vim-sleuth",
    })
end)

-- Easy table editor
add({
  source = 'SCJangra/table-nvim',
})
-- Lazy load it for Markdown
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    require('mini.deps').now(function()
      require('table-nvim').setup({})
    end)
  end,
})
