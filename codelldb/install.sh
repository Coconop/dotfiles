#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKDIR=$(pwd)

# Determine your CPU's architecture to download the correct version of codelldb
ARCH=$(lscpu | grep -oP 'Architecture:\s*\K.+')
if [ "$ARCH" != "x86_64" ]; then
  echo "WARNING: $ARCH might not be supported"
  exit 1
fi

cd ${SCRIPT_DIR}
sudo curl -L "https://github.com/vadimcn/vscode-lldb/releases/download/v1.7.0/codelldb-${ARCH}-linux.vsix" -o "codelldb-${ARCH}-linux.zip"

# Unzip only the required folders (extension/adapter and extension/lldb)
unzip "codelldb-${ARCH}-linux.zip" "extension/adapter/*" "extension/lldb/*"
mv extension/ codelldb_adapter

# Remove the downloaded zip file
sudo rm "codelldb-${ARCH}-linux.zip"

# Create a symbolic link from codelldb_adapter/adapter/codelldb to /usr/bin/codelldb
sudo ln -s $(pwd)/codelldb_adapter/adapter/codelldb /usr/bin/codelldb

# Test the installation by running codelldb -h
codelldb -h

