local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Step one ===================================================================

now(function() vim.cmd('colorscheme catppuccin-mocha') end)

now(function() require('mini.statusline').setup() 
    -- override default behavior
    local statusline = require 'mini.statusline'
    -- Simpler cursor location: LINE:COLUMN (no current/total)
    statusline.section_location = function()
        return 'l%l:c%v'
    end
    -- Do not show diff resume
    -- TODO customize vim.b.minidiff_summary_string
    statusline.section_diff = function()
        return ''
    end
    --TODO customize vim.b.minigit_summary_string
end)

now(function() require('mini.tabline').setup() end)

now(function() require('mini.notify').setup() end)

-- TODO does not seem to work well, nvim-web-devicons seems better
-- now(function() require('mini.icons').setup()end)

-- Step two ===================================================================

later(function() require('mini.extra').setup() 
end)

later(function() require('mini.ai').setup() end)

--later(function() require('mini.animate').setup() end)

-- TODO configure 
later(function() require('mini.clue').setup() end)

--later(function() require('mini.comment').setup() end)

later(function() require('mini.completion').setup() end)

later(function() require('mini.diff').setup({
    view = { 
        style = 'sign',
        signs = {
            add = '+',
            change = '~',
            delete = '-',
        },
    }
}) end)

later(function() require('mini.files').setup()
    vim.keymap.set(
    'n',
    '<leader>fe',
    ':lua MiniFiles.open()<CR>',
    {desc = 'MiniFiles'}
    )
end)

later(function() require('mini.fuzzy').setup() end)

later(function() require('mini.git').setup() end)

later(function()
    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },

            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

later(function() require('mini.jump').setup() end)

-- Fancy indent visualization
--later(function() require('mini.indentscope').setup() end)

later(function() require('mini.pairs').setup() end)

later(function() require('mini.pick').setup()
    vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fg', MiniPick.builtin.grep_live, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fh', MiniPick.builtin.help, { desc = 'Help Tags' })
    -- require MiniExtra
    vim.keymap.set('n', '<leader>fd', MiniExtra.pickers.diagnostic, { desc = "Browse diagnostics" })
    vim.keymap.set('n', '<leader>fr', function() 
        MiniExtra.pickers.lsp({scope = 'references'})
    end, {desc = "Find symbol references under cursor" })
    vim.keymap.set('n', '<leader>fs', function() 
        MiniExtra.pickers.lsp({scope = 'document_symbol'})
    end, {desc = "Find symbols" })
end)

later(function() require('mini.surround').setup() end)

