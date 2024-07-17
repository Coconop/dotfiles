#!/bin/bash

# This script set things up my sweet environment on any linux machine
# Tested on Debian and WSL Ubuntu

# TODO Automatic download of latest file versions from github ?

# TODO discriminate Ubuntu vs Debian

# TODO Handle offline install

# TODO Handle proxy

# Colors for fancy output
Red='\033[0;31m'; BRed='\033[1;31m';
Gre='\033[0;32m'; BGre='\033[1;32m';
Yel='\033[0;33m'; BYel='\033[1;33m';
Blu='\033[0;34m'; BBlu='\033[1;34m';
Mag='\033[0;35m'; BM='\033[1;35m';
Cya='\033[0;36m'; BCya='\033[1;36m';
Whi='\033[0;37m'; BWhi='\033[1;37m';
None='\033[0m' # Return to default colour

check_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "${Cya}Running on $NAME${None}"
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    echo -e "${Cya}Running on $DISTRIB_DESCRIPTION${None}"
  elif [ -f /etc/debian_version ]; then
    echo -e "${Cya}Running on Debian $(cat /etc/debian_version)${None}"
  elif [ -f /etc/redhat-release ]; then
    echo -e "${Cya}Running on $(cat /etc/redhat-release)${None}"
  else
    echo -e "${Cya}Linux distribution not recognized${None}"
  fi
}

detect_package_manager() {

  if [ -f /etc/os-release ]; then
    . /etc/os-release

    case "$ID" in
      debian|ubuntu)
        package_manager="apt"
        package_opts="--no-install-recommends"
        ;;
      rocky|centos|rhel)
        package_manager="dnf"
        package_opts=""
        ;;
      *)
        echo -e "${Cya}Unsupported distribution: $ID${None}"
        package_manager=""
        package_opts=""
        exit 1
        ;;
    esac
  else
    echo -e "${Cya}Unable to detect OS${None}"
    package_manager=""
  fi

  echo -e "${Cya}Package Manager: $package_manager${None}"
}

# TODO Check for minimal rust version required by tools
check_rust() {
  if command -v rustc >/dev/null 2>&1; then
    rust_version=$(rustc --version)
    echo -e "${Yel}Rust is installed: $rust_version${None}"
    install_rust=false
  else
    echo -e "${Cya}Rust is not installed${None}"
    install_rust=true
  fi
}

check_go() {
  if command -v go >/dev/null 2>&1; then
    go_version=$(go version)
    echo -e "${Yel}Go is installed: $go_version${None}"
    install_go=false
  else
    echo -e "${Cya}Go is not installed${None}"
    install_go=true
  fi
}

check_rust_analyzer() {
  if command -v rust-analyzer >/dev/null 2>&1; then
    echo -e "${Yel}rust-analyzer is installed${None}"
    install_rust_analyzer=false
  else
    echo -e "${Cya}rust-analyzer is not installed${None}"
    install_rust_analyzer=true
  fi
}

check_fzf() {
  if command -v fzf >/dev/null 2>&1; then
    fzf_version=$(fzf --version)
    echo -e "${Yel}FZF is installed: $fzf_version${None}"
    install_fzf=false
  else
    echo -e "${Cya}FZF is not installed${None}"
    install_fzf=true
  fi
}


install_fonts() {
  # local font="JetBrainsMono"
  local font="0xProto"
  local archive="$font.tar.xz"
  local destination_dir="/usr/local/share/fonts/$font"

  # Check if the archive exists
  if [ ! -f "$archive" ]; then
    echo "Archive $archive not found."
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$archive
  fi

  # Create the destination directory if it doesn't exist
  sudo mkdir -p "$destination_dir"

  # Extract the archive to the destination directory
  sudo tar -xvf "$archive" -C "$destination_dir"

  # Refresh the font cache
  sudo fc-cache -f -v

  echo "Fonts installed successfully."
}

# Function to display help message
display_help() {
    echo -e "${Yel}Usage: $0 [options]${None}"
    echo -e "${Yel}Options:${None}"
    echo -e "${Yel}  -u       Update and install packets${None}"
    echo -e "${Yel}  -s       Create a SSH key if absent${None}"
    echo -e "${Yel}  -r       Install Rust Env and tools${None}"
    echo -e "${Yel}  -g       Install Go Env and tools${None}"
    echo -e "${Yel}  -t       Install tools from source${None}"
    echo -e "${Yel}  -o       Upgrade OS${None}"
    echo -e "${Yel}  -c       Setup config${None}"
    exit 1
}

ask_for_confirmation() {
  local prompt="$1"

  while true; do
    read -rp "$prompt (y/n): " response
    case "$response" in
      [Yy]* ) return 0;;  # Return true (0) for yes
      [Nn]* ) return 1;;  # Return false (1) for no
      * ) echo -e "${Red}Please answer yes or no.${None}";;
    esac
  done
}

check_neovim() {
  if command -v nvim >/dev/null 2>&1; then
    neovim_version=$(nvim --version)
    echo -e "${Yel}nvim is installed: $neovim_version${None}"
  else
    echo -e "${Cya}nvim is not installed${None}"
  fi
  #https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source
  if ask_for_confirmation "Install Last Neovim version from source ?"; then
    echo -e "${Cya}Neovim will be launched interactively for 1st installation${None}"
    sudo $package_manager remove neovim
    # TODO check for neovim git repo, cd to it and:
    # sudo cmake --build build/ --target uninstall
    TOTO=`pwd`
    mkdir -p $HOME/git
    cd $HOME/git
    git clone https://github.com/neovim/neovim.git || true
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd $TOTO
    source ${HOME}/.bashrc
    /usr/local/bin/nvim
  fi
}

check_tmux() {
  if command -v tmux >/dev/null 2>&1; then
    tmux_version=$(tmux -V)
    echo -e "${Yel}tmux is installed: $tmux_version${None}"
  else
    echo -e "${Cya}tmux is not installed${None}"
  fi
  # https://github.com/tmux/tmux/wiki/Installing#from-version-control
  if ask_for_confirmation "Install Last tmux version from source ?"; then
    echo -e "${Yel}WARNING packet are probably missing. Better install manually${None}"
    sudo $package_manager remove tmux
    TOTO=`pwd`
    mkdir -p $HOME/git
    cd $HOME/git
    git clone https://github.com/tmux/tmux.git || true
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true
    cd tmux
    git checkout 3.4
    sh autogen.sh
    ./configure
    make && sudo make install
    source ${HOME}/.bashrc
  fi
}

while getopts "usrgtoc" opt; do
  case $opt in
    u) update_packets=true ;;
    s) ssh_gen=true ;;
    r) rust_tools=true ;;
    g) go_tools=true ;;
    t) src_tools=true ;;
    o) os_upd=true ;;
    c) set_cfg=true ;;
    \?) display_help ;;
  esac
done

# Avoid Owner issues
if [ "$EUID" -eq 0 ]; then
    echo -e "${Red} Do NOT run me with sudo${None}"
    exit 1
fi

detect_package_manager

set -e
if grep -qEi "(icrosoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
    echo -e "${Red}Damn, we are in Microsoft WSL :(${None}"
    IS_IN_WSL=1
else
    IS_IN_WSL=0
fi

check_distro

if [[ $update_packets = true ]]; then
    # TODO test if we have connection (ping)
    # TODO test if we need a proxy (curl)

    # Any update ?
    echo -e "${Cya}Updating system...${None}"
    sudo ${package_manager} update


    # Installing useful/required packets
    echo -e "${Cya}Installing packets...${None}"
    sudo ${package_manager} install  ${package_opts} vim curl tree git git-lfs rsync silversearcher-ag -y || true
    sudo ${package_manager} install  ${package_opts} dos2unix python3-dev python3-pip python3-setuptools python3-tk -y || true
    sudo ${package_manager} install  ${package_opts} python3-wheel python3-venv pipx -y || true
    sudo ${package_manager} install  ${package_opts} gdb make gcc clang cscope p7zip-full -y || true
    sudo ${package_manager} install  ${package_opts} autoconf automake -y || true
    sudo ${package_manager} install  ${package_opts} ninja-build gettext cmake unzip build-essential -y || true
    sudo ${package_manager} install  ${package_opts} libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev -y || true
    sudo ${package_manager} install  ${package_opts} libevent-dev ncurses-dev build-essential bison pkg-config libevent ncurses -y || true #Debian/ubuntu
    sudo ${package_manager} install  ${package_opts} libevent-2.1-7 ncurses-base ncurses-bin ncurses-term yacc libncurses-dev libncurses5 -y || true
    sudo ${package_manager} install  ${package_opts} libevent-devel ncurses-devel gcc make bison pkg-config -y || true #  RHEL/CentOs


    # Could be installed via Cargo but would need manual config
    sudo ${package_manager} install  ${package_opts} bat ripgrep fd-find -y || true

    echo -e "${Red}Do $package_manager search for missing packets and find their true name${None}"

fi

if [[ $os_upd = true ]]; then
    if ask_for_confirmation "Are you sure you want to upgrade system?"; then
        echo -e "${Cya}Upgrading system...${None}"
        sudo ${package_manager} upgrade -y
        echo -e "${Cya}Cleaing up...${None}"
        sudo ${package_manager} autoremove -y

        # Update trust store certificates
        echo -e "${Cya}Updating certificates...${None}"
        sudo ${package_manager} install  apt-transport-https ca-certificates -y
        sudo update-ca-certificates
    else
        echo -e "${Yel}Skipping upgrade${None}"
    fi
fi

if [[ $ssh_gen = true ]]; then
    # Create SSH folder if it does not exists yet
    mkdir -p ${HOME}/.ssh

    if [ -f ${HOME}/.ssh/id_rsa ]; then
        echo -e "${Yel}An SSH key is already present!${None}"
    else
        # Generate SSH key
        echo -e "${Cya}Generating Passphrase...${None}"
        echo -e "${Yel}Be sure to remember the passhrase !${None}"
        ssh-keygen -t rsa -b 4096
    fi
fi

if [[ $rust_tools = true ]]; then

    check_rust
    if [[ $install_rust = true ]]; then
        echo -e "${Cya}Installing Rust...${None}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi

    check_rust_analyzer
    if [[ $install_rust_analyzer = true ]]; then
        curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
        # It might fail here. Checkout https://askubuntu.com/a/1387286 and https://askubuntu.com/a/1501564 for WSL
        chmod +x ~/.local/bin/rust-analyzer
    fi

    echo -e "${Cya}Installing rust-written tools${None}"
#    cargo install ripgrep
    cargo install eza
#    cargo install --locked bat
    cargo install --locked broot
#    cargo install fd-find
    cargo install du-dust

    ln -snfv $(which fdfind) ~/.local/bin/fd
    # Need to be launched once to install shell scripts
    broot

fi

if [[ $go_tools = true ]]; then
    check_go
    if [[ $install_go = true ]]; then
        echo -e "${Cya}Installing Go...${None}"
        # TODO retrieve last version
        wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
        rm go1.22.5.linux-amd64.tar.gz
        export PATH=$PATH:/usr/local/go/bin
    fi

    echo -e "${Cya}Installing go-written tools${None}"
    go install github.com/jesseduffield/lazygit@latest
fi

if [[ $src_tools = true ]]; then

    check_neovim

    check_tmux

    if ask_for_confirmation "Do you want to install NerdFont ?"; then
        install_fonts
    fi

    # Sweet Fuzzy finder
    check_fzf
    if [[ $install_fzf = true ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi

    # Install universal ctags to use with fzf
    work_dir=${pwd}
    mkdir -p ${HOME}/git
    cd ${HOME}/git
    if [ -d "ctags" ]; then
        echo -e "${Yel}Ctags already installed${None}"
    else
        git clone https://github.com/universal-ctags/ctags.git
        cd ctags
        ./autogen.sh
        ./configure
        make
        sudo make install
    fi
    cd ${work_dir}

    # Fix bad command
    #pipx install thefuck || true
fi

if [[ $set_cfg = true ]]; then
    # For Neovim, btw
    mkdir -p ${HOME}/.config

    # Get the directory containing the script
    script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    if [[ $script_dir != *"dotfiles"* ]]; then
	    echo -e "{Red}Script dir = $script_dir$, pwd = ${pwd} 'dotfiles' not found {None}"
	    exit
    fi
    echo -e "${Cya}Linking files from ${script_dir} to ${HOME}/ ...${None}"

    sudo ln -sfnv ${script_dir}/.vimrc ${HOME}/.vimrc
    sudo ln -sfnv ${script_dir}/.vim ${HOME}/.vim
    sudo ln -sfnv ${script_dir}/nvim ${HOME}/.config/nvim

    sudo ln -sfnv ${script_dir}/.bashrc ${HOME}/.bashrc
    sudo ln -sfnv ${script_dir}/.bash_prompt ${HOME}/.bash_prompt
    sudo ln -sfnv ${script_dir}/.bash_git ${HOME}/.bash_git
    sudo ln -sfnv ${script_dir}/.bash_git_completion ${HOME}/.bash_git_completion

    sudo ln -sfnv ${script_dir}/.tmux.conf ${HOME}/.tmux.conf

    sudo ln -sfnv ${script_dir}/.dir_colors ${HOME}/.dir_colors

    sudo chown -h $USER:$USER ${HOME}/.vimrc ${HOME}/.vim ${HOME}/.config/nvim
    sudo chown -h $USER:$USER ${HOME}/.bashrc ${HOME}/.bash_prompt ${HOME}/.bash_git ${HOME}/.bash_git_completion

    if ask_for_confirmation "Do you want to create symlinks for root too?"; then
        sudo mkdir -p /root/.config
        echo -e "${Cya}Linking files from ${script_dir} to /root/ ...${None}"
        sudo ln -sfnv ${script_dir}/.bashrc /root/.bashrc
        sudo ln -sfnv ${script_dir}/.bash_prompt /root/.bash_prompt
        sudo ln -sfnv ${script_dir}/.bash_git /root/.bash_git
        sudo ln -sfnv ${script_dir}/.bash_git_completion /root/.bash_git_completion

        sudo ln -sfnv ${script_dir}/.tmux.conf /root/.tmux.conf

        sudo ln -sfnv ${script_dir}/.dir_colors /root/.dir_colors

        sudo ln -sfnv ${script_dir}/.vimrc /root/.vimrc
        sudo ln -sfnv ${script_dir}/.vim /root/.vim
        sudo ln -sfnv ${script_dir}/nvim /root/.config/nvim

        # In WSL we need to tweak tmux config
        if [ $IS_IN_WSL -eq 1 ]; then
            sudo ln -sfnv ${script_dir}/.tmux_wsl.conf /root/.tmux_wsl.conf
        else
            sudo touch /root/.tmux_wsl.conf
        fi
    fi

    # In WSL we need to tweak tmux config
    if [ $IS_IN_WSL -eq 1 ]; then
        sudo ln -sfnv ${script_dir}/.tmux_wsl.conf ${HOME}/.tmux_wsl.conf
    else
        touch ${HOME}/.tmux_wsl.conf
    fi

    # Moment of truth !
    echo -e "${Cya}Sourcing...${None}"
    source ${HOME}/.bashrc

    echo -e "${Cya}Disable annoying bash bell (beep)${None}"
    inputrc_file="/etc/inputrc"

    # Check if the file exists
    if [ ! -f "$inputrc_file" ]; then
        echo -e "${Cya}Error: $inputrc_file does not exist.${None}"
    else
        echo -e "${Cya}Disable terminal bell${None}"
        # Uncomment the line if it's commented
        sudo sed -i 's/#set bell-style/set bell-style/' "$inputrc_file"

        # Check if the line with "set bell-style" exists and edit it accordingly
        if grep -q "^set bell-style" "$inputrc_file"; then
            sudo sed -i 's/^set bell-style .*/set bell-style none/' "$inputrc_file"
        else
            # If the line doesn't exist, append it to the end of the file
            echo "set bell-style none" | sudo tee -a "$inputrc_file"
        fi
    fi

    # Hush !
    echo -e "${Cya}Hush login${None}"
    touch ${HOME}/.hushlogin

    # Git config TODO complete
    echo -e "${Cya}Global git config${None}"
    git config --global core.editor "nvim"
    git config --global core.autocrlf input

    # Handy alias for bat
    mkdir -p ~/.local/bin
    ln -nfvs /usr/bin/batcat ~/.local/bin/bat

    # Launch Vim and Neovim and execute PlugInstall command
    echo -e "${Cya}Setting up [Neo]Vim...${None}"
    vim -c 'PlugInstall' -c 'qa!'
    # Shall need time to load and install TODO
    # nvim --headless +PlugInstall +qa
fi

echo -e "${Gre}All set up Captain! ${None}"
