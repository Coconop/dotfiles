#!/bin/bash

# This assume a fresh install Pi Lite

set -euo pipefail

# Colors for fancy output
Red='\033[0;31m'; BRed='\033[1;31m';
Gre='\033[0;32m'; BGre='\033[1;32m';
Yel='\033[0;33m'; BYel='\033[1;33m';
Blu='\033[0;34m'; BBlu='\033[1;34m';
Mag='\033[0;35m'; BMag='\033[1;35m';
Cya='\033[0;36m'; BCya='\033[1;36m';
Whi='\033[0;37m'; BWhi='\033[1;37m';
None='\033[0m' # Return to default colour

ask_for_confirmation() {
  local prompt="$1"
  while true; do
      read -rp "$(echo -e ${Mag}${prompt}${None}" (y/n):")" response
      case "$response" in
          [Yy]* ) return 0;;  # Return true (0) for yes
          [Nn]* ) return 1;;  # Return false (1) for no
          * ) echo -e "${Red}Please answer yes or no.${None}";;
      esac
  done
}

# System update
echo -e "${Blu}Updating packages...${None}"

sudo apt update
sudo apt full-upgrade -y

# EEPROM
echo -e "${Blu}Checking eeprom updates...${None}"

sudo rpi-eeprom-update

if ask_for_confirmation("${Blu}Update EEPROM?${Red} This will automatically REBOOT!"); then
    sudo rpi-eeprom-update -a
    sudo reboot
fi


# Packages
echo -e "${Blu}Installing packages...${None}"

sudo apt install -y build-essential clang ninja-build cmake pkg-config \
  libssl-dev curl git unzip btop pass gnupg2 vim ufw unbound

# fzf
echo -e "${Blu}Installing fzf...${None}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# neovim
echo -e "${Blu}Installing neovim \\o/...${None}"
mkdir -p "$HOME/git"
git clone https://github.com/neovim/neovim.git "$HOME/git/neovim"
WORKDIR=$(pwd)
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux-arm64.deb

# dotfiles
echo -e "${Blu}Custom dotfiles 8) ...${None}"
cd "$HOME/git"
DOTFILES="$HOME/git/dotfiles"
git clone https://github.com/Coconop/dotfiles.git "$DOTFILES"

cd "$DOTFILES/bash"
./linkme.sh
cd "$DOTFILES/colors"
./linkme.sh
cd "$DOTFILES/neovim"
./linkme.sh
cd "$DOTFILES/tmux"
./linkme.sh
cd "$DOTFILES/vim"
./linkme.sh
cd "$DOTFILES/readline"
./linkme.sh
cd "$DOTFILES/git"
./git_config.sh

# Docker
echo -e "${Blu}Installing docker...${None}"
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc | cut -f1)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker

# Rust
echo -e "${Blu}Installing rust... slowly... ¯\\_(ツ)_/¯${None}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo install ripgrep fd-find bat tree-sitter-cli

# pass
gpg --full-generate-key
echo -e "${Cya}pass init GPG-KEY-ID"
echo -e "${Yel}Create PAT to access dotfiles repo${None}"
echo -e "${Cya}pass add git/github/coconop${None}"
echo -e "${Cya}$DOTFILES/git/git_config.sh"

# Storage
echo -e "${Blu}Setting media...${None}"
MOUNTPOINT="/mnt/media"
sudo mkdir -p "$MOUNTPOINT"
lsblk -f
sudo blkid
echo -e "Add to /etc/fstab:"
echo -e "UUID=XXXXXXX  /mnt/media  ext4  defaults,nofail,x-systemd.device-timeout=10  0  2"
echo -e "\n\t${Red}Reboot to ensure automount is working${None}\n"

JELLYFIN="$HOME/docker/jellyfin"
mkdir -p "$JELLYFIN/{config,cache}"
touch "$JELLYFIN/docker-compose.yml"
cat << EOF > "$JELLYFIN/docker-compose.yml"
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    # Optional - specify the uid and gid you would like Jellyfin to use instead of root
    #user: uid:gid
    ports:
      - 8096:8096/tcp
      - 7359:7359/udp
    volumes:
      - $JELLYFIN/config:/config
      - $JELLYFIN/cache:/cache
      - type: bind
        source:$MOUNTPOINT 
        target: /media
    restart: 'unless-stopped'
    # Optional - alternative address used for autodiscovery
    #environment:
    #  - JELLYFIN_PublishedServerUrl=http://example.com
    # Optional - may be necessary for docker healthcheck to pass if running in host network mode
    #extra_hosts:
    #  - 'host.docker.internal:host-gateway'
EOF

