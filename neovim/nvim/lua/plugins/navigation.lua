local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Seemless navigation between (Neo)Vim and Tmux panes
now(function()
    add({
        source = 'christoomey/vim-tmux-navigator'
    })
end)

-- Hybrid filetree viewer with oil/vineagar spirit
later(function()
    require('mini.files').setup({
        windows = {
            preview = false,
        }
    })
    vim.keymap.set("n", "<leader>ee", ":lua MiniFiles.open()<CR>", { desc = "[E]xplorer" })
end)

-- Awesome picker
now(function()
    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = {'nvim-lua/plenary.nvim'},
        checkout = '0.1.8'

    })

    require('telescope').setup{
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--hidden",
                "--trim",
                "--glob", "!.git/*",
            }
        },
        pickers = {
            find_files = {
                -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            },
        },
    }
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep live" })
    vim.keymap.set("n", "<leader>fc", function()
        builtin.live_grep({
            glob_pattern = "*.{c,h}",
            -- file_ignore_patterns = { "%.py$", "%.pyx$"},
            prompt_title = "Live Grep (.c/.h files)",
        })
    end, { desc = "[F]ind grep live in [C]" })
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
    vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[F]indings [M]arks" })
    vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "[F]indings Fu[Z]zy" })

    -- Extensions

    -- Custom function to have lazy:'build' or vimplug:'do' equivalent
    -- It takes param that are passed to 'hooks' (cf mini.deps doc)
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
		source = "nvim-telescope/telescope-ui-select.nvim",
	})
    require("telescope").load_extension("ui-select")
end)
