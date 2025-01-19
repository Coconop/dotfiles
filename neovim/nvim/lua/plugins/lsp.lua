return {
	-- LSP settings by language
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Global lsp config ----------------------------------------------

			-- Always let space fro diagnostics, signs, etc
			vim.opt.signcolumn = "yes"

			-- Setup keymaps etc ONLY if there is an attached LSP
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("<leader>ld", require("telescope.builtin").lsp_definitions, "goto [D]efinition")
					map("<leader>lD", vim.lsp.buf.declaration, "goto [D]eclaration")
					map("<leader>lr", require("telescope.builtin").lsp_references, "goto [R]eferences")
					map("<leader>lI", require("telescope.builtin").lsp_implementations, "goto [I]mplementation")
					map("<leader>lt", require("telescope.builtin").lsp_type_definitions, "goto [T]ype definition")
					map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "document [S]ymbols")
					map("<leader>lR", vim.lsp.buf.rename, "[R]ename")
					map("<leader>lc", vim.lsp.buf.code_action, "[C]ode action", { "n", "x" })
				end,
			})

			-- Add autocompletion for all languages
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Change diagnostic symbols in the sign column (gutter)
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- Per language config --------------------------------------------

			-- Rust
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						chechOnSave = {
							command = "clippy",
						},
					},
				},
			})

			-- C/C++
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			-- Bash
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})

			-- Lua (Neovim)
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
							workspaceDelay = -1,
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
						telemetry = {
							enable = false,
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
		end,
	},

	-- Use virtual lines to display accurate LSP diagnostics
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
			-- Disable virtual_text since it's redundant due to lsp_lines.
			vim.diagnostic.config({ virtual_text = false })
			-- -- Don't underline HINTs, can be annoying with #[cfg()]
			vim.diagnostic.config({
				underline = { severity = { min = vim.diagnostic.severity.INFO } },
			})
			-- We want to be able to toggle it if its to annyoing
			vim.keymap.set("", "<Leader>vl", require("lsp_lines").toggle, { desc = "[V]irtual [L]ines toggle" })
			-- Disable for floating windows (Lazy, Mason)
			vim.api.nvim_create_autocmd("WinEnter", {
				callback = function()
					local floating = vim.api.nvim_win_get_config(0).relative ~= ""
					vim.diagnostic.config({
						virtual_text = floating,
						virtual_lines = not floating,
					})
				end,
			})
			-- Disabled by default, toggle to enablv
			vim.diagnostic.config({ virtual_lines = false })
		end,
	},

	-- Auto format code on save
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>bf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "[B]uffer [F]ormat",
			},
		},
		opts = { -- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				--python = { "isort", "black" },
				rust = { "rustfmt" },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500 },
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	-- nvim-cmp source for neovim's built-in language server client
	{
		"hrsh7th/cmp-nvim-lsp",
	},

	-- Auto complete filesystem path
	{
		"hrsh7th/cmp-path",
	},

	-- Setup autocompletion
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			-- Add parentheses after selecting function or method item
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- Add fancy icons to display completion source
			local kind_icons = {
				Text = "",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰇽",
				Variable = "󰂡",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "󰅲",
			}

			cmp.setup({

				formatting = {
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
						-- Source
						vim_item.menu = ({
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[LaTeX]",
						})[entry.source.name]
						return vim_item
					end,
				},

				-- Disabling completion in certain contexts
				enabled = function()
					local context = require("cmp.config.context")

					-- disable autocompletion in prompt (ex: telescope)
					---@diagnostic disable-next-line: deprecated
					local buftype = vim.api.nvim_buf_get_option(0, "buftype")
					if buftype == "prompt" then
						return false
					end

					-- disable autocompletion in comments
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end,

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					-- more sources
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- Auto-install LSP, Formatters, linters
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				-- Prioritize system install over Mason install
				PATH = "append",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"bashls",
					-- Prefer system install
					--"rust_analyzer"
				},
				-- Use system install
				automatic_installation = { exclude = { "rust_analyzer" } },
				handlers = {
					--- this first function is the "default handler"
					--- it applies to every language server without a "custom handler"
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				},
			})
		end,
	},
}
