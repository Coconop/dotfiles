# What I did

* Raspberry Pi 4B
* Geeek Pi Ice tower + fan (no case with 3v little fan: noisy and innefficient)
* https://www.raspberrypi.com/software/
* Pi Lite OS 64bit
* No WiFi (ethernet -> ensure wifi disabled with boot configuration)
* Custom hostname, enable SSH
* Kingston 120GB SSD -> format

* Reboot + wait (avahi daemon need to start for DNS hostname resolution)
* OR -> get IP address of Pi from Box

```bash
sudo apt update
sudo apt upgrade
```


# git

# rust

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

* bat
* ripgrep
* find-fd
* eza

# fzf

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

# pass

``` bash
sudo apt install pass
```

# other

``` bash
sudo apt install btop
```

# neovim

* https://github.com/neovim/neovim.git

From sources, of course

Dependencies:
* clang or gcc v4.9+
* cmake v3.16+ with TLS/SSL (shell script from https://cmake.org/download/)

``` bash
sudo apt-get install ninja-build gettext cmake curl build-essential git
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux-arm64.deb
```

`arm64` because `aarch64` returned by:
``` bash
uname-m
# or
arch
```


## tree-sitter

cli:
- tar
- curl

```bash
cargo install --locked tree-sitter-cli
```

Careful with api break -> `checkout v0.9.3`


# dotfiles

https://github.com/Coconop/dotfiles.git

# docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

# HOMELAB

## External hard drive

```bash
# Harddrive
lsblk

# Custom mount point
sudo mkdir -p /mnt/media

# Format
# sudo mkfs.ext4 /dev/sda1

# Get the UUID for auto-mount
sudo blkid /dev/sda1
```

if windows ntfs:

`sudo apt install ntfs-3g`
Edit `/etc/fstab`
```bash
UUID=xxxx-xxxx  /mnt/media  ntfs-3g  defaults,nofail,uid=1000,gid=1000,umask=0022  0  0
```

Bus-powered: append to /boot/firmware/config.txt: `max_usb_current=1` for give it that sweet 1.2A

## Media center

make a docker-compose.yml with jellyfin as media center and bazarr for subtitles fetcher

## Library population
No auto download from pi
```bash
rsync -avh --progress MY_MOVIE.mkv USER@REMOTE:/mnt/media/movies/
```


