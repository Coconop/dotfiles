#!/bin/bash
# Install latest version of shellcheck to run smoothly with
# bash-langage-server version installed via Mason

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../sourceme.sh"

FOLDER="shellcheck-stable"
ARCHIVE="${FOLDER}.linux.x86_64.tar.xz"
LATEST_VERSION_URL="https://github.com/koalaman/shellcheck/releases/download/stable/${ARCHIVE}"

echo -e "Downloading ${LATEST_VERSION_URL}"

if ! curl -OL "${LATEST_VERSION_URL}"; then
  echo "Failed to download ${ARCHIVE}"
  exit 1
fi

echo "Extracting..."
if ! tar -xf "${ARCHIVE}"; then
  echo "Failed to extract ${ARCHIVE}"
  exit 1
fi

rm ${ARCHIVE}

echo "Adding to PATH..."
export PATH="$(pwd)/${FOLDER}:${PATH}"

SOURCE_DIR="${SCRIPT_DIR}/.bash.d/shellcheck.bash"
echo "Create/overwrite file to be sourced..."
echo "export PATH=\"$(pwd)/${FOLDER}:\${PATH}\"" > "${SOURCE_DIR}"
echo -e "\nDone"

echo -e "Please re-source ${Yel}.bashrc${None} so change can be effective!"
echo -e "Ensure you have the following version:"
SC_VERSION=$(shellcheck --version | grep "version:" | awk '{print $2}')
echo -e "shellcheck --version: ${Yel}${SC_VERSION}${None}"

