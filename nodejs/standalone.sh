#!/bin/bash

# Define variables
NODE_VERSION="v22.13.0"
NODE_DISTRO="node-${NODE_VERSION}-linux-x64"
NODE_URL="https://nodejs.org/dist/${NODE_VERSION}/${NODE_DISTRO}.tar.xz"

# Download Node.js tarball
echo "Downloading Node.js ${NODE_VERSION}..."
curl -O "${NODE_URL}"

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download ${NODE_URL}"
  exit 1
fi

# Extract the tarball
echo "Extracting ${NODE_DISTRO}.tar.xz..."
tar -xf "${NODE_DISTRO}.tar.xz"

# Check if extraction was successful
if [ $? -ne 0 ]; then
  echo "Failed to extract ${NODE_DISTRO}.tar.xz"
  exit 1
fi

# Add the extracted folder to PATH
echo "Adding ${NODE_DISTRO} to PATH..."
export PATH="$(pwd)/${NODE_DISTRO}/bin:$PATH"

# Confirm installation
echo "Node.js ${NODE_VERSION} installed. Verifying version..."
node --version
npm --version

# Provide instructions to permanently update PATH
echo "Add this to bashrc:"
echo "export PATH=\"$(pwd)/${NODE_DISTRO}/bin:\$PATH\""

