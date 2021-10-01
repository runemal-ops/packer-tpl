#!/bin/sh -eux

# Set user
USER="${USER:-runemal}";

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/$USER}";

# Set correct permissions in case
chown -R $USER:$USER /home/$USER/;

# Get public key
pubkey_url="https://gist.githubusercontent.com/runemal-ops/8ee89ae2a980a75875bef0430dc23e52/raw/bfa41003b3c45996c6542b460f0919a18c639c02/id_rsa.pub";
mkdir -p $HOME_DIR/.ssh;
if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;
elif command -v fetch >/dev/null 2>&1; then
    fetch -am -o $HOME_DIR/.ssh/authorized_keys "$pubkey_url";
else
    echo "Cannot download $USER public key";
    exit 1;
fi

# Set correct permissions
chown -R $USER $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;
