local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Essential plugins
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('nvim-telescope/telescope.nvim', {['tag']='0.1.8' })
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do']='cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' })
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'

-- Interface
Plug 'folke/which-key.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'

-- Git
Plug 'tpope/vim-fugitive'
Plug 'rhysd/conflict-marker.vim'
Plug 'rbong/vim-flog'
Plug 'lewis6991/gitsigns.nvim'

-- LSP Zone
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug('VonHeikemen/lsp-zero.nvim', {['branch']='v3.x'})

vim.call('plug#end')

