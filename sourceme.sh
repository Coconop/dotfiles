#!/bin/bash

# Stop at 1st error
set -e

# Colors for fancy output
Red='\033[0;31m'; BRed='\033[1;31m';
Gre='\033[0;32m'; BGre='\033[1;32m';
Yel='\033[0;33m'; BYel='\033[1;33m';
Blu='\033[0;34m'; BBlu='\033[1;34m';
Mag='\033[0;35m'; BMag='\033[1;35m';
Cya='\033[0;36m'; BCya='\033[1;36m';
Whi='\033[0;37m'; BWhi='\033[1;37m';
None='\033[0m' # Return to default colour

if [ "$EUID" -eq 0 ]; then
    echo -e "${Red}Do NOT run me with sudo!${None}"
    exit 1
fi


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

safe_symlink() {
    local SOURCE="$1"
    local TARGET="$2"

    # Check if source exists
    if [ ! -e "$SOURCE" ]; then
        echo -e "${Red}Error: Source '$SOURCE' does not exist.${None}" >&2
        return 1
    fi

    # Check if target exists and is not already the correct symlink
    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        # Check if it's already the correct symlink
        if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
            echo -e "${Blue}Symlink already exists and points to the correct location.${None}"
            return 0
        fi

        # Create a backup with timestamp
        local TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        local BACKUP="${TARGET}.backup_${TIMESTAMP}"

        echo -e "${Yel}Backing up existing '$(basename "$TARGET")' to '$(basename "$BACKUP")'${None}"

        # Handle the case where target is a symlink to a non-existent file
        if [ -L "$TARGET" ] && [ ! -e "$TARGET" ]; then
            mv "$TARGET" "$BACKUP"
        else
            cp -a "$TARGET" "$BACKUP"  # -a preserves permissions and works with directories
        fi
    fi

    # Create the symlink
    echo "Creating symlink from '$SOURCE' to '$TARGET'"
    safe_symlink "$SOURCE" "$TARGET"

    return $?
}

