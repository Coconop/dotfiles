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

if [ "$EUID" -eq 0 ]; then
    echo -e "${Red} Do NOT run me with sudo${None}"
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

# Stop at 1st error
set -e
