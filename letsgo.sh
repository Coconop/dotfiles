#!/bin/bash

# This script set things up my sweet environment on any linux machine
# Tested on Debian and WSL Ubuntu

# TODO Automatic download of latest file versions from github ?

# TODO discriminate Ubuntu vs Debian

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

# Update trust store certificates
echo -e "${Cya}Updating certificates...${None}"
sudo apt install apt-transport-https ca-certificates -y
sudo update-ca-certificates 

# Installing useful/required packets
echo -e "${Cya}Installing packets...${None}"
sudo apt install --no-install-recommends vim tmux curl tree git git-lfs rsync -y
sudo apt install --no-install-recommends dos2unix python3-dev python3-pip python3-setuptools python3-tk -y
sudo apt install --no-install-recommends python3-wheel python3-venv -y
sudo apt install --no-install-recommends make gcc cmake cscope -y

# Create SSH folder if it does not exists yet
mkdir -p ~/.ssh

if [ -f ~/.ssh/id_rsa ]; then
    echo -e "${Yel}An SSH key is already present!${None}"
else
    # Generate SSH key
    echo -e "${Cya}Generating Passphrase...${None}"
    echo -e "${Yel}Be sure to remember the passhrase !${None}"
    ssh-keygen -t rsa -b 4096 
fi

# Get the directory containing the script
script_dir="$(dirname "$0")"
echo -e "${Cya}Copying files from ${script_dir} to ~/ ...${None}"
cp -frv ${script_dir}/bash/. ~/
cp -frv ${script_dir}/tmux/. ~/
cp -frv ${script_dir}/vim/.vimrc ~/
mkdir -vp ~/.vim/colors
cp -frv ${script_dir}/vim/colors/. ~/.vim/colors/
mkdir -vp ~/.vim/after
cp -frv ${script_dir}/vim/after/. ~/.vim/after/
mkdir -vp ~/.vim/plugin
cp -frv ${script_dir}/vim/plugin/. ~/.vim/plugin/

# In WSL we need to tweak tmux config
if [ $IS_IN_WSL -eq 1 ]; then
    echo 'source-file ~/.tmux_wsl.conf' | sudo tee -a ~/.tmux.conf > /dev/null
fi

# Moment of truth !
echo -e "${Cya}Sourcing...${None}"
source ~/.bashrc

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
sudo ln -sfn ~/.vimrc /root/.vimrc
sudo ln -sfn ~/.vim /root/.vim
sudo ln -sfn ~/.dir_colors /root/.dir_colors
sudo ln -sfn ~/.bash_prompt /root/.bash_prompt
sudo ln -sfn ~/.bash_git /root/.bash_git
sudo ln -sfn ~/.bash_git_completion /root/.bash_git_completion
sudo ln -sfn ~/.bashrc /root/.bashrc

# Hush !
touch ~/.hushlogin

# Git config TODO complete
git config --global core.editor "vim"

echo -e "${Gre}All set up Captain! ${None}"
