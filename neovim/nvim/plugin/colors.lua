local add, now  = MiniDeps.add, MiniDeps.now

now(function()
    add('folke/tokyonight.nvim')
    add('navarasu/onedark.nvim')
    add({ source = 'catppuccin/nvim', name = 'catppuccin-nvim' })
    add('rebelot/kanagawa.nvim')
    add('chriskempson/base16-vim')
    add('shaunsingh/nord.nvim')
end)
