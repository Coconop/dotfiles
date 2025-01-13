#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

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
