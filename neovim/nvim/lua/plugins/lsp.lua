return {
	-- LSP settings by language
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Rust
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						chechOnSave = {
							command = "clippy",
						},
					},
				},
			})

			-- C/C++
			lspconfig.clangd.setup({})

			-- Lua (Neovim)
			lspconfig.lua_ls.setup({
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
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
							-- library = vim.api.nvim_get_runtime_file("", true)
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

			-- Extend config
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = "yes"

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			-- This is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				end,
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
			vim.keymap.set("", "<Leader>vl", require("lsp_lines").toggle, { desc = "Toggle lsp virtual_lines" })
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
				"<leader>cf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
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
			-- Customize formatters
			--formatters = {
			--    shfmt = {
			--        prepend_args = { "-i", "2" },
			--    },
			--},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	-- nvim-cmp source for neovim's built-in language server client
	{
		"hrsh7th/cmp-nvim-lsp",
		config = function()
			local cmp = require("cmp").setup({
				sources = {
					{
						name = "nvim_lsp",
					},
				},
			})
			-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.clangd.setup({
				capabilities = capabilities,
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
		end,
	},

	-- Auto complete filesystem path
	{
		"hrsh7th/cmp-path",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{
						name = "path",
						option = {
							-- Options go into this table
						},
					},
				},
			})
		end,
	},
	-- Setup autocompletion
	{
		"L3MON4D3/LuaSnip",
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
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					--['<C-b>'] = cmp.mapping.scroll_docs(-4),
					--['<C-f>'] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
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
					-- { name = 'luasnip', option = { use_show_condition = false } },
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
