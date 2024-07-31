#!/bin/bash

set -e
echo "Saving paths"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKDIR=$(pwd)

echo "Checking architecture"
ARCH="$(uname -m)"
if [ "$ARCH" != "x86_64" ]; then
    echo "WARNING: $ARCH might not be supported"
fi

curl -s --head https://github.com | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null
if [ $? -ne 0 ]; then
    echo "Unable to connect to GitHub."
    exit 1
else
    echo "Connection test OK"
fi

get_latest_release() {
    curl -sLI https://github.com/vadimcn/vscode-lldb/releases/latest | grep tag/ | tr -d '\r' | awk '{print $2}' | sed 's/tag/download/'
}


LATEST_RELEASE="$(get_latest_release)"
if [ -z "$LATEST_RELEASE" ]; then
    echo "Failed to fetch the latest release version."
    exit 1
else
    echo "Latest release: ${LATEST_RELEASE}"
fi

ZIP_NAME="codelldb-${ARCH}-linux.vsix"
URL="$LATEST_RELEASE/$ZIP_NAME"

echo "Downloading ${URL}..."
cd ${SCRIPT_DIR}
ARCHIVE="codelldb-${ARCH}-linux.zip"
curl -L "${URL}" -o "${ARCHIVE}"

echo "Unzipping required folders"
unzip "${ARCHIVE}" "extension/adapter/*" "extension/lldb/*"
mv extension/ codelldb_adapter

echo "Cleaning archive..."
sudo rm "${ARCHIVE}"

echo "Creating symlink..."
sudo ln -s $(pwd)/codelldb_adapter/adapter/codelldb /usr/bin/codelldb

cd $WORKDIR
codelldb -h

