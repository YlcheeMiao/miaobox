#!/usr/bin/env bash
BIN_DIR=${BIN_DIR:-$HOME/.bin}
mkdir -p $BIN_DIR

#if [ "$(id -u)" -eq 0 ]; then
#    echo 'This script must NOT be run as root' >&2
#    exit 1
#fi

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run by root' >&2
    exit 1
fi

# install exa as replacement for ls
wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
unzip exa-linux-x86_64-0.9.0.zip
mv exa-linux-x86_64 $BIN_DIR/exa
ln -fs $BIN_DIR/exa /usr/local/bin/
rm exa-linux-*

# set the right time zone (exa needs this)
apt update
DEBIAN_FRONTEND=noninteractive  apt install -y --no-install-recommends tzdata
ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
