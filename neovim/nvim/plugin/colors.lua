local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    add('folke/tokyonight.nvim')
    add('navarasu/onedark.nvim')
    add({ source = 'catppuccin/nvim', name = 'catppuccin-nvim' })
    add('rebelot/kanagawa.nvim')
end)
