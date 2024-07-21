#!/bin/bash

# Colors for fancy output
Red='\033[0;31m'; BRed='\033[1;31m';
Gre='\033[0;32m'; BGre='\033[1;32m';
Yel='\033[0;33m'; BYel='\033[1;33m';
Blu='\033[0;34m'; BBlu='\033[1;34m';
Mag='\033[0;35m'; BMag='\033[1;35m';
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

# Stop at 1st error
set -e

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
    sudo ${package_manager} install  ${package_opts} python3-wheel python3-venv -y || true
    sudo ${package_manager} install  ${package_opts} gdb make gcc clang cscope p7zip-full -y || true
    sudo ${package_manager} install  ${package_opts} autoconf automake -y || true
    sudo ${package_manager} install  ${package_opts} ninja-build gettext cmake unzip build-essential -y || true

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
    bash "${script_dir}/rust/install.sh"
fi

if [[ $go_tools = true ]]; then
    bash "${script_dir}/go/install.sh"
fi

if [[ $src_tools = true ]]; then
    bash "${script_dir}/fzf/install.sh"
    bash "${script_dir}/ctags/install.sh"
fi

if [[ $set_cfg = true ]]; then
    # Get the directory containing the script
    script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    if [[ $script_dir != *"dotfiles"* ]]; then
	    echo -e "{Red}Script dir = $script_dir$, pwd = ${pwd} 'dotfiles' not found {None}"
	    exit
    fi
    echo -e "${Cya}Linking files from ${script_dir} to ${HOME}/ ...${None}"
    bash "${script_dir}/linkall.sh"
fi

echo -e "${Cya}Sourcing...${None}"
source ${HOME}/.bashrc
echo -e "${Gre}All set up Captain! ${None}"
