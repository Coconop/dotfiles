dir_preview='eza -T --icons=always -a -L 2 -I ".git|target|node_modules" --color=always {}'
file_preview='bat -n --color=always --line-range :500 {}'
show_file_or_dir_preview="if [ -d {} ]; then $dir_preview; else $file_preview; fi"

# Use ripgrep, show hidden files, ignore files from .git/ directories
export FZF_DEFAULT_COMMAND='rg --hidden --glob "!.git/**"'

# Catppuccin theme
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --multi"

# Ctrl+t: find file/dir
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview '$show_file_or_dir_preview'"

# Alt+c: change dir
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview '$dir_preview'"

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Options for path completion (e.g. vim **<TAB>)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'

# Options for directory completion (e.g. cd **<TAB>)
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# remap Alt-c to Alt-f (easier with homerow keyboard)
bind -m emacs-standard '"\ef": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ef": "\C-z\ec\C-z"'
bind -m vi-insert '"\ef": "\C-z\ec\C-z"'

# Upgrade fzf
alias fzfup='cd "$(dirname $(which fzf))/.." && git pull && ./install'


# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments ($@) to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview "$dir_preview"		    "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"	    "$@" ;;
    ssh)          fzf --preview 'dig {}'		    "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

_fzf_find_word() {
# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Open the file in Neovim
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case --hidden --glob \"!.git/**\""
INITIAL_QUERY=""
fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})'
}

alias nw=_fzf_find_word
