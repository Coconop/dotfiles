#!/usr/bin/env/bash

# Ensure `pass` is installed!

KEYRING_DIR="$HOME"/.config/python_keyring
KEYRING_CFG="$KEYRING_DIR"/keyring.cfg
# Assume there is a single repo
REPO="$(grep index-url < "$HOME"/.config/pip/pip.conf | awk '{print $3}')"


if [[ -f $KEYRING_CFG ]]; then
    echo "$KEYRING_CFG already set"
    cat "$KEYRING_CFG"
else
    mkdir -p "$KEYRING_DIR"
    echo "[backend]" >> "$KEYRING_CFG"
    echo "default-keyring = keyring_pass.PasswordStoreBackend" >> "$KEYRING_CFG"

    echo "pass set as default python keyring backend"
    echo "keyring set $REPO [USERNAME]"
fi

