
local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('nvim-tree/nvim-web-devicons')
end)
