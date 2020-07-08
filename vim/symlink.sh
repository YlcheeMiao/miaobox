#!/bin/bash

# simply links the vimrc files without installing all plugins

[ -f ~/.vimrc ] && cp -f ~/.vimrc ~/.vimrc_bak

ln -fs `pwd`/_vimrc ~/.vimrc
ln -fs `pwd`/_ideavimrc ~/.ideavimrc
