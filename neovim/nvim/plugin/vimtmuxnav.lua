local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add('christoomey/vim-tmux-navigator')
end)
