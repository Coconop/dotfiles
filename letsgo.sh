#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

source ${SCRIPT_DIR}/sourceme.sh

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

if [[ $update_packets = true ]]; then
    # TODO test if we have connection (ping)
    # TODO test if we need a proxy (curl)
    check_distro
    detect_package_manager
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
    sudo ${package_manager} install  ${package_opts} shellcheck || true
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
    bash "${SCRIPT_DIR}/rust/install.sh"
fi

if [[ $go_tools = true ]]; then
    bash "${SCRIPT_DIR}/go/install.sh"
fi

if [[ $src_tools = true ]]; then
    bash "${SCRIPT_DIR}/fzf/install.sh"
    bash "${SCRIPT_DIR}/ctags/install.sh"
fi

if [[ $set_cfg = true ]]; then
    # Get the directory containing the script
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    if [[ $SCRIPT_DIR != *"dotfiles"* ]]; then
	    echo -e "${Red}Script dir = $SCRIPT_DIR$, pwd = $(pwd) 'dotfiles' not found ${None}"
	    exit
    fi
    echo -e "${Cya}Linking files from ${SCRIPT_DIR} to ${HOME}/ ...${None}"
    bash "${SCRIPT_DIR}/linkall.sh"
fi

echo -e "${Cya}Sourcing...${None}"
source ${HOME}/.bashrc
echo -e "${Gre}All set up Captain! ${None}"
