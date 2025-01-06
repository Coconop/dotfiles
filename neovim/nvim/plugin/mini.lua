local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Step one ===================================================================

now(function() vim.cmd('colorscheme tokyonight-night') end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.notify').setup() end)
now(function() require('mini.icons').setup() end)

-- Step two ===================================================================
later(function() require('mini.extra').setup() 
    -- MiniPick
    vim.keymap.set('n', '<leader>fd', MiniExtra.pickers.diagnostic, { desc = "Browse diagnostics" })
    vim.keymap.set('n', '<leader>fr', MiniExtra.pickers.lsp(
    {scope = 'references'}), 
    {desc = "Find symbol references under cursor" })
    vim.keymap.set('n', '<leader>fsr', MiniExtra.pickers.lsp(
    {scope = 'references'}), 
    {desc = "Find symbol references under cursor" })
    vim.keymap.set('n', '<leader>fs', MiniExtra.pickers.lsp(
    {scope = 'document_symbol'}), 
    {desc = "Find symbols" })
end)

later(function() require('mini.ai').setup() end)
-- TODO configure 
later(function() require('mini.clue').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.diff').setup() end)

later(function() require('mini.files').setup()
    vim.keymap.set(
    'n',
    '<leader>fe',
    ':lua MiniFiles.open()<CR>',
    {desc = 'MiniFiles'}
    )
end)

later(function() require('mini.fuzzy').setup() end)

later(function()
    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
            todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),

            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.pick').setup()
    vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fg', MiniPick.builtin.grep_live, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader>fh', MiniPick.builtin.help, { desc = 'Help Tags' })
end)
later(function() require('mini.surround').setup() end)


