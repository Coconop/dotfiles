local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug 'tpope/vim-sensible'
Plug 'folke/tokyonight.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', {['tag']='0.1.8' })
--or                                , { 'branch': '0.1.x' }

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
-- When plugin creation level is reached
--Plug('nvim-treesitter/playground')

Plug 'mbbill/undotree'

Plug 'tpope/vim-fugitive'

-- LSP Zone
--  Uncomment the two plugins below if you want to manage the language servers from neovim
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'

Plug('VonHeikemen/lsp-zero.nvim', {['branch']='v3.x'})
-- LSP Zone

Plug 'folke/which-key.nvim'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'nvim-lualine/lualine.nvim'

vim.call('plug#end')

