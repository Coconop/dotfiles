return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.rust_analyzer.setup({
                settings = {
                    ['rust-analyzer'] = {
                        chechOnSave = {
                            command = "clippy"
                        }
                    }
                }
            })
        end
    }
}
