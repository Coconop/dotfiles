return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Browse diagnostics" })
			vim.keymap.set("n", "<leader>fr", builtin.grep_string, { desc = "Grep Str under cursor" })
			vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "Incoming calls" })
			vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, { desc = "Outgoing calls" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find symbols" })
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
}
