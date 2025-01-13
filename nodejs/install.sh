#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

NODE_VERSION="v22.13.0"
NODE_DISTRO="node-${NODE_VERSION}-linux-x64"
NODE_URL="https://nodejs.org/dist/${NODE_VERSION}/${NODE_DISTRO}.tar.xz"

echo -e "Downloading Node.js ${Yel}${NODE_VERSION}${None}..."
curl -O "${NODE_URL}"

if [ $? -ne 0 ]; then
  echo "Failed to download ${NODE_URL}"
  exit 1
fi

echo "Extracting ${NODE_DISTRO}.tar.xz..."
tar -xf "${NODE_DISTRO}.tar.xz"

if [ $? -ne 0 ]; then
  echo "Failed to extract ${NODE_DISTRO}.tar.xz"
  exit 1
fi

rm "${NODE_DISTRO}.tar.xz"

echo "Adding ${NODE_DISTRO} to PATH..."
export PATH="$(pwd)/${NODE_DISTRO}/bin:${PATH}"

SOURCE_DIR="${SCRIPT_DIR}/../bash/.bash.d/node.bash"
echo "Create/overwrite file to be sourced..."
echo "export PATH=\"$(pwd)/${NODE_DISTRO}/bin:\${PATH}\"" > $SOURCE_DIR
echo -e "\nDone"

echo -e "Please re-source ${Yel}.bashrc${None} so change can be effective!"
echo -e "Ensure you have the following output:"
echo -e "node --version: ${Yel}$(node --version)${None}"
echo -e "npm --version: ${Yel}$(npm --version)${None}"

