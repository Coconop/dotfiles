# Use ripgrep, show hidden files, ignore files from .git/ directories
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

# Preview with bat
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --height 40% --border"


# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -a -C -I \".git|.node_modules|target\" {} | head -200'"


# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Search and open in neovim (support multiple file selection)
alias nn='nvim $(fzf -m --preview="bat --color=always {}")'
# Upgrade fzf
alias fzfup='cd ~/git/fzf && git pull && ./install'

# remap ALT-C to ALT-F (easier with homerow keyboard)
bind -m emacs-standard '"\ef": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ef": "\C-z\ec\C-z"'
bind -m vi-insert '"\ef": "\C-z\ec\C-z"'
