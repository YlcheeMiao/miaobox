#!/bin/bash

if [ -z "$CONFIG_ROOT" ]; then
    echo 'CONFIG_ROOT docker build environment variable is not set' >&2
    exit 1
fi

if [[ $MY_DOCKER_BUILD != 1 ]]; then
    [ -f ~/.vimrc ] && cp -f ~/.vimrc ~/.vimrc_bak
    ln -fs $CONFIG_ROOT/vim/_vimrc ~/.vimrc
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install VimPlug plugins (in .vimrc) non-interactively
vim +'PlugInstall' +qa

mkdir -p ~/.config/TabNine

ln -fs $CONFIG_ROOT/vim/tabnine_config.json ~/.config/TabNine/
ln -fs $CONFIG_ROOT/vim/_vimrc ~/.vimrc
