#!/usr/bin/env bash
BIN_DIR=${BIN_DIR:-$HOME/.bin}
mkdir -p $BIN_DIR

# miscellaneous tools
# dman is a man page that runs search on https://manpages.ubuntu.com/
wget https://manpages.ubuntu.com/dman -O $BIN_DIR/dman
chmod +x $BIN_DIR/dman
ln -fs $BIN_DIR/dman /usr/local/bin/dman

wget https://github.com/b4b4r07/gomi/releases/download/v1.1.1/gomi_linux_x86_64.tar.gz
tar xf gomi_linux_x86_64.tar.gz
mv gomi $BIN_DIR/
ln -fs $BIN_DIR/gomi /usr/local/bin/gomi
rm -rf gomi_*