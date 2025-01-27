# I use (n)vim, BTW
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR=nvim
# Use vi mode in Readline (Warning: it is NOT VIM)
#set -o vi

# Use blazingly fast and pretty tool
alias ll='eza -alF --icons=always'

# Prompt for SSH credentials from Terminal, no GUI
unset SSH_ASKPASS
# Same for GPG
export GPG_TTY="$(tty)"

# C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Rust
source "${HOME}/.cargo/env"
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/

# Go
export PATH=${PATH}:/usr/local/go/bin:${HOME}/go/bin

# Autocorrect bad commands
#eval "$(thefuck --alias)"

# Local folder for custom scripts/exe
mkdir -p "${HOME}/.local/bin"
export PATH=${HOME}/.local/bin:${PATH}

# Disable Ctrl-s/Ctrl-q Flow Control (Pause/Resume)
stty -ixon

# Replaces dir names with the results of word expansion when using completion
shopt -s direxpand
