local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('williamboman/mason.nvim')
    require('mason').setup()
end)

later(function()
  add('stevearc/conform.nvim')

  require('conform').setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
      javascript = { "prettier" },
      json = { "prettier" },
      lua = { "stylua" },
      python = { "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
  })
end)

later(function()
    add('neovim/nvim-lspconfig')

    local custom_on_attach = function(client, buf_id)
        -- Set up 'mini.completion' LSP part of completion
        vim.bo[buf_id].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
        -- Mappings are created globally with `<Leader>l` prefix (for simplicity)
    end

    -- All language servers are expected to be installed with 'mason.vnim'
    local lspconfig = require('lspconfig')

    -- Bash
    --lspconfig.bashls.setup({ on_attach = custom_on_attach })

    -- Rust
    lspconfig.rust_analyzer.setup({ on_attach = custom_on_attach })

    -- C/C++
    lspconfig.clangd.setup({ on_attach = custom_on_attach })

    -- Lua
    lspconfig.lua_ls.setup({ on_attach = custom_on_attach })

    -- Python
    --lspconfig.pyright.setup({ on_attach = custom_on_attach })

    -- Typescript and Javascript
    --lspconfig.ts_ls.setup({ on_attach = custom_on_attach })

    -- Go
    --lspconfig.gopls.setup({ on_attach = custom_on_attach })
end)

later(function() add('rafamadriz/friendly-snippets') end)

later(function ()
    add({
        source = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    })
    require("lsp_lines").setup()

    vim.diagnostic.config({
        -- Disable virtual_text since it's redundant due to lsp_lines.
        virtual_text = false,
        -- Don't underline HINTs, can be annoying with #[cfg()]
        underline = { severity = { min = vim.diagnostic.severity.INFO } },
    })
end)
