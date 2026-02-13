local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Seemless navigation between Neovim and Tmux panes
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
later(function()
    add({
        source = 'ibhagwan/fzf-lua',
        depends = {'nvim-mini/mini.icons'},
    })

    -- Keybindings
    vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fg", require("fzf-lua").live_grep, { desc = "[F]ind [G]rep live" })
    vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "[F]ind [B]uffers" })
    vim.keymap.set("n", "<leader>fh", require("fzf-lua").helptags, { desc = "[F]ind [H]elp tags" })
    vim.keymap.set("n", "<leader>fr", require("fzf-lua").grep_cword, { desc = "[F]ind [R]ef under cursor" })
    vim.keymap.set("n", "<leader>fR", require("fzf-lua").resume, { desc = "[F]indings [R]esume" })
    vim.keymap.set("n", "<leader>fp", require("fzf-lua").complete_path, { desc = "Complete [F]uzzy [P]ath" })
    vim.keymap.set("n", "<leader>fn", function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })
    vim.keymap.set("n", "<leader>fm", require("fzf-lua").marks, { desc = "[F]indings [M]arks" })
end)
