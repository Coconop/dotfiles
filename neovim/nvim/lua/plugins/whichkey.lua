return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
				ellipsis = "…",
				-- set to false to disable all mapping icons,
				-- both those explicitly added in a mapping
				-- and those from rules
				mappings = true,
				-- See `lua/which-key/icons.lua` for more details
				-- Set to `false` to disable keymap icons from rules
				--@type wk.IconRule[]|false
				rules = {
					{ plugin = "telescope.nvim", pattern = "telescope", icon = "", color = "blue" },
					{ plugin = "todo-comments.nvim", cat = "file", name = "TODO" },
					{ plugin = "lazy.nvim", cat = "filetype", name = "lazy" },

					-- 1st pattern matching wins: sort by priority

					-- Strip 1st letter: in "[F]ind", [ and ] are magic chars for regex
					{ pattern = "ind ", icon = " ", color = "green" },
					{ pattern = "rep ", icon = "", color = "cyan" },
					{ pattern = "iagnostic ", icon = " ", color = "green" },
					{ pattern = "SP ", icon = " ", color = "orange" },
					{ pattern = "it ", icon = " ", color = "red" },
					{ pattern = "otif ", icon = " ", color = "blue" },
					{ pattern = "onflict ", icon = " ", color = "red" },
					{ pattern = "pell ", icon = " ", color = "blue" },
					{ pattern = "ormat", icon = " ", color = "cyan" },
					{ pattern = "im ", icon = " ", color = "blue" },
					{ pattern = "ich ", icon = " ", color = "green" },

					-- Fallback
					{ pattern = "search", icon = " ", color = "green" },
					{ pattern = "test", cat = "filetype", name = "neotest-summary" },
					{ pattern = "lazy", cat = "filetype", name = "lazy" },
					{ pattern = "toggle", icon = " ", color = "yellow" },
				},
				-- use the highlights from mini.icons
				-- When `false`, it will use `WhichKeyIcon` instead
				colors = true,
				-- used by key format
				keys = {
					Up = " ",
					Down = " ",
					Left = " ",
					Right = " ",
					C = "<C-> ",
					M = "<M-> ",
					D = "Del ",
					S = "<S->",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = " ",
					ScrollWheelUp = " ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "F1 ",
					F2 = "F2 ",
					F3 = "F3 ",
					F4 = "F4 ",
					F5 = "F5 ",
					F6 = "F6 ",
					F7 = "F7 ",
					F8 = "F8 ",
					F9 = "F9 ",
					F10 = "F10 ",
					F11 = "F11 ",
					F12 = "F12 ",
				},
			},
		},
		spec = {
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>s", group = "[S]pell" },
			{ "<leader>c", group = "[C]onflict" },
			{ "<leader>n", group = "[N]otif" },
		},
		keys = {
			{
				"<leader>wk",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "[W]hich [K]ey Local",
			},
		},
	},
}
