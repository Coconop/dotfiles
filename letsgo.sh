#!/bin/bash

# This script set things up my sweet environment on any linux machine
# Tested on Debian and WSL Ubuntu

# TODO Automatic download of latest file versions from github ?

# TODO discriminate Ubuntu vs Debian

# TODO Options to skip apt update/upgrade

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

set -e
if grep -qEi "(icrosoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
    echo -e "${Red}Damn, we are in Microsoft WSL :(${None}"
    IS_IN_WSL=1
else
    echo -e "${Yel}Native linux here :) ${None}"
    IS_IN_WSL=0
fi

# TODO test if we have connection (ping)
# TODO test if we need a proxy (curl)

# Any update ?
echo -e "${Cya}Updating system...${None}"
sudo apt update
echo -e "${Cya}Upgrading system...${None}"
sudo apt upgrade -y
echo -e "${Cya}Cleaing up...${None}"
sudo apt autoremove -y

# Update trust store certificates
echo -e "${Cya}Updating certificates...${None}"
sudo apt install apt-transport-https ca-certificates -y
sudo update-ca-certificates

# Installing useful/required packets
echo -e "${Cya}Installing packets...${None}"
sudo apt install --no-install-recommends vim tmux curl tree git git-lfs rsync silversearcher-ag 7z -y
sudo apt install --no-install-recommends dos2unix python3-dev python3-pip python3-setuptools python3-tk -y
sudo apt install --no-install-recommends python3-wheel python3-venv -y
sudo apt install --no-install-recommends gdb make gcc cmake cscope fzf -y

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

# Get the directory containing the script
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo -e "${Cya}Copying files from ${script_dir} to ${HOME}/ ...${None}"

sudo ln -sfnv ${script_dir}/.vimrc ${HOME}/.vimrc
sudo ln -sfnv ${script_dir}/.vim ${HOME}/.vim

sudo ln -sfnv ${script_dir}/.bashrc ${HOME}/.bashrc
sudo ln -sfnv ${script_dir}/.bash_prompt ${HOME}/.bash_prompt
sudo ln -sfnv ${script_dir}/.bash_git ${HOME}/.bash_git
sudo ln -sfnv ${script_dir}/.bash_git_completion ${HOME}/.bash_git_completion

sudo ln -sfnv ${script_dir}/.tmux.conf ${HOME}/.tmux.conf

sudo ln -sfnv ${script_dir}/.dir_colors ${HOME}/.dir_colors

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
    echo "Error: $inputrc_file does not exist."
else
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

echo -e "${Cya}Pimping root...${None}"
sudo ln -sfnv ${HOME}/.vimrc /root/.vimrc
sudo ln -sfnv ${HOME}/.vim /root/.vim
sudo ln -sfnv ${HOME}/.dir_colors /root/.dir_colors
sudo ln -sfnv ${HOME}/.bash_prompt /root/.bash_prompt
sudo ln -sfnv ${HOME}/.bash_git /root/.bash_git
sudo ln -sfnv ${HOME}/.bash_git_completion /root/.bash_git_completion
sudo ln -sfnv ${HOME}/.bashrc /root/.bashrc

# Hush !
touch ${HOME}/.hushlogin

# Git config TODO complete
git config --global core.editor "vim"

# Rust stuff
#curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
#chmod +x ~/.local/bin/rust-analyzer

echo -e "${Gre}All set up Captain! ${None}"
