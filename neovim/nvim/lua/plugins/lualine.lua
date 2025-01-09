--- @param trunc_width number trunctates component when screen width is less than trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller than hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- @param always_trunc boolean whether to truncate regardless of window width
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis, always_trunc)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif always_trunc then
			return str:sub(1, trunc_len) .. (string.len(str) < trunc_len and "" or "...")
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local colors = {
				blue = "#80a0ff",
				cyan = "#79dac8",
				black = "#080808",
				white = "#c6c6c6",
				red = "#ff5189",
				violet = "#d183e8",
				grey = "#303030",
			}

			local bubbles_theme = {
				normal = {
					a = { fg = colors.black, bg = colors.violet },
					b = { fg = colors.white, bg = colors.grey },
					c = { fg = colors.white },
				},

				insert = { a = { fg = colors.black, bg = colors.blue } },
				visual = { a = { fg = colors.black, bg = colors.cyan } },
				replace = { a = { fg = colors.black, bg = colors.red } },

				inactive = {
					a = { fg = colors.white, bg = colors.black },
					b = { fg = colors.white, bg = colors.black },
					c = { fg = colors.white },
				},
			}

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					--theme = bubbles_theme,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "branch", fmt = trunc(80, 21, 10, false, true) },
						"diff",
						"diagnostics",
					},
					lualine_c = {
						{
							"buffers",
							show_filename_only = true, -- Shows shortened relative path when set to false.
							hide_filename_extension = true, -- Hide filename extension when set to true.
							show_modified_status = true, -- Shows indicator when the buffer is modified.
							mode = 0, -- 0: Shows buffer name
							-- 1: Shows buffer index
							-- 2: Shows buffer name + buffer index
							-- 3: Shows buffer number
							-- 4: Shows buffer name + buffer number
							max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
							-- it can also be a function that returns
							-- the value of `max_length` dynamically.
							filetype_names = {
								TelescopePrompt = "Telescope",
								dashboard = "Dashboard",
								fzf = "FZF",
							}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
							-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
							use_mode_colors = false,
							-- |!\ BUG
							--buffers_color = {
							--    -- Same values as the general color option can be used here.
							--    active = 'lualine_{section}_normal',     -- Color for active buffer.
							--    inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
							--},
							symbols = {
								modified = " ●", -- Text to show when the buffer is modified
								alternate_file = "#", -- Text to show to identify the alternate file
								directory = "", -- Text to show when the buffer is a directory
							},
						},
					},
					lualine_d = { "FugitiveHead" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}
