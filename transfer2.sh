#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

# Script to transfer config files between machines using SCP
# Usage: ./transfer_configs.sh [user@]hostname

# Exit on error
set -e

# Check if target host is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 [user@]hostname"
    exit 1
fi

# Target host
TARGET_HOST="$1"

# Files and directories to transfer
CONFIG_FILES=(
    "$HOME/.gitconfig"
    "$HOME/proxy.sh"
)

CONFIG_DIRS=(
    "$HOME/.ssh"
    "$HOME/.gnupg"
    "$HOME/git/dotfiles"
    "$HOME/ca"
)

# Create a temporary directory for staging
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Function to clean up on exit
cleanup() {
    echo -e "${Red}Cleaning up temporary files...${None}"
    rm -rf "$TEMP_DIR"
    echo -e "Done"
}
trap cleanup EXIT

# Copy files to staging area
echo "=== Preparing files for transfer ==="
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Copying $file"
        mkdir -p "$TEMP_DIR/$(dirname "${file#$HOME/}")"
        cp "$file" "$TEMP_DIR/${file#$HOME/}"
    else
        echo -e "${Yel}Warning: $file not found, skipping${None}"
    fi
done

# Copy directories to staging area
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Copying $dir"
        mkdir -p "$TEMP_DIR/$(dirname "${dir#$HOME/}")"
        cp -R "$dir" "$TEMP_DIR/${dir#$HOME/}"
    else
        echo "${Yel}Warning: $dir not found, skipping${None}"
    fi
done

# Handle SSH keys with proper permissions
if [ -d "$TEMP_DIR/.ssh" ]; then
    echo "Setting proper permissions for SSH files"
    chmod 700 "$TEMP_DIR/.ssh"
    find "$TEMP_DIR/.ssh" -type f -name "id_*" -not -name "*.pub" -exec chmod 600 {} \;
    find "$TEMP_DIR/.ssh" -type f -name "*.pub" -exec chmod 644 {} \;
fi

# Handle GPG files with proper permissions
if [ -d "$TEMP_DIR/.gnupg" ]; then
    echo "Setting proper permissions for GPG files"
    chmod 700 "$TEMP_DIR/.gnupg"
    find "$TEMP_DIR/.gnupg" -type f -exec chmod 600 {} \;
fi

# Create archive
ARCHIVE_NAME="$(whoami)_cfg_$(date +%Y%m%d_%H%M%S).tar.gz"
echo "Creating archive: $ARCHIVE_NAME"
tar -czf "/tmp/$ARCHIVE_NAME" -C "$TEMP_DIR" .

# Transfer archive to target machine
echo "=== Transferring files to $TARGET_HOST ==="
scp "/tmp/$ARCHIVE_NAME" "$TARGET_HOST:/tmp/"

# Extract files on remote machine
echo "=== Extracting files on $TARGET_HOST ==="
ssh "$TARGET_HOST" "mkdir -p ~/config_backup && \
    tar -xzf /tmp/$ARCHIVE_NAME -C ~ && \
    echo 'Configuration files have been transferred and extracted.' && \
    rm /tmp/$ARCHIVE_NAME"

# Clean up local archive
rm "/tmp/$ARCHIVE_NAME"

echo "=== Transfer complete ==="
echo "${Gre}Configuration successfully exported to $TARGET_HOST${None}"
