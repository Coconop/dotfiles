-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
  vim.o.termguicolors = true
  -- vim.cmd('colorscheme catppuccin')
end)

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.icons').setup() end)
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

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    -- require('mini.clue').gen_clues.z(),
  },
}) end)

now(function()
    add({
        source = 'catppuccin/nvim',
		name = "catppuccin",
    })
    vim.cmd([[colorscheme catppuccin-mocha]])
end)

-- Safely execute later
later(function() require('mini.ai').setup() end)
later(function() require('mini.comment').setup() end)
-- later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.indentscope').setup({
    delay = 0,
    animation = function(n, s) return 0 end
}) end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.hipatterns').setup({
    highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
}) end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.cursorword').setup() end)

later(function()
    require('mini.files').setup()
    vim.keymap.set("n", "<leader>fe", ":lua MiniFiles.open()<CR>", { desc = "File [Ex]plorer" })
end)

now(function()
    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = {'nvim-lua/plenary.nvim'},
        checkout = '0.1.8'

    })
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep live" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp tags" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    vim.keymap.set("n", "<leader>fr", builtin.grep_string, { desc = "[F]ind [R]ef under cursor" })
    vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "[F]ind [I]ncoming calls" })
    vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, { desc = "[F]ind [O]utgoing calls" })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "[F]ind [S]ymbols" })
    vim.keymap.set("n", "<leader>fR", builtin.resume, { desc = "[F]indings [R]esume" })
    vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })

    local function make_fzf_native(params)
        vim.cmd("lcd " .. params.path)
        vim.cmd("!make -s")
        -- vim.cmd("cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release")
        vim.cmd("lcd -")
    end
	add({
		source = "nvim-telescope/telescope-fzf-native.nvim",
        hooks = {
            post_install = make_fzf_native,
            post_checkout = make_fzf_native
        },
	})
    require("telescope").load_extension("fzf")

	add({
		"nvim-telescope/telescope-ui-select.nvim",
	})
    require("telescope").load_extension("ui-select")
end)

