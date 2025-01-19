return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "rust", "bash", "json", "toml", "python" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                -- TODO https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
                -- Automatically install missing parsers when entering buffer (need tree-sitter CLI)
                -- auto_install = true,
            })
        end
    }
}
