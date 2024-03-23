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
sudo apt install --no-install-recommends vim tmux curl tree git git-lfs \
	rsync xclip \ 
	dos2unix python3-dev python3-pip python3-setuptools python3-tk \
	python3-wheel python3-venv\
	make gcc cmake cscope \
	-y

# Create SSH folder if it does not exists yet
mkdir -p ~/.ssh

if [ -e ~/.ssh/id_rsa ]; then
	# Generate SSH key
	echo -e "${Cya}Generating Passphrase...${None}"
	echo -e "${Yel}Be sure to remember the passhrase !${None}"
	ssh-keygen -t rsa -b 4096 
else
	echo -e "${Yel}An SSH key is already present!${None}"
fi

# Ensure agent is running: https://stackoverflow.com/questions/40549332/
timeout 0.3 ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
	# Could not open a connection to your authentication agent.
	echo -e "${Red}No SSH agent is running! Start it and Add key:${None}"
	echo -e "${Red}eval `ssh-agent`${None}"
	echo -e "${Red}ssh-add ~/.ssh/id_rsa${None}"
else
	#Add our freshly generated Key
	ssh-add ~/.ssh/id_rsa
fi

# Get the directory containing the script
script_dir="$(dirname "$0")"
echo -e "${Cya}Copying files from ${script_dir}...${None}"
rsync -rtvP ${script_dir}/bash -r ~/
rsync -rtvP ${script_dir}/tmux -r ~/
rsync -rtvP ${script_dir}/vim -r ~/

# In WSL we need to tweak tmux config
if [ $IS_IN_WSL -eq 1 ]then;
	echo 'source-file ~/.tmux_wsl.conf' | tee -a ~/.tmux.conf > /dev/null
fi

# Moment of truth !
echo -e "${Cya}Sourcing...${None}"
source ~/.bashrc

echo -e "${Cya}Disable annoying bash bell (beep):${None}"
# Comment any existing "set bell-style"
sudo sed -i 's/set bell-style/\#set bell-style/g' /etc/inputrc
# Be sure to disable it
echo 'set bell-style none' | sudo tee -a /etc/inputrc > /dev/null

# Hush !
touch .hushlogin

echo -e "${Gre}All set up! Captain${None}"
