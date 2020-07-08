#!/usr/bin/env bash
BIN_DIR=${BIN_DIR:-$HOME/.bin}
mkdir -p $BIN_DIR
mkdir -p $HOME/.config

if [ -z "$CONFIG_ROOT" ]; then
    echo 'CONFIG_ROOT environment variable is not set' >&2
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    echo 'This script must NOT be run as root' >&2
    exit 1
fi

# install oh-my-zsh non-interactive
# no longer need this because we use antigen
#sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

curl -L git.io/antigen > ~/.antigen.zsh
# activate it first here to install the plugins.
# the script will be sourced again in .zshrc
[ -f $HOME/.apply-antigen.sh ] && zsh $HOME/.apply-antigen.sh

# install scm_breeze
git clone git://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh

# https://starship.rs/
# fancy command line prompt
wget https://starship.rs/install.sh -O starship-install.sh
chmod +x starship-install.sh
./starship-install.sh -y --bin-dir $BIN_DIR

# Fuzzy matching
git clone --depth 1 https://github.com/junegunn/fzf.git $BIN_DIR/fzf
$BIN_DIR/fzf/install --all --64

ln -fs $CONFIG_ROOT/zsh/starship.toml ~/.config/
ln -fs $CONFIG_ROOT/zsh/_git.scmbrc ~/.git.scmbrc
ln -fs $CONFIG_ROOT/zsh/_zshrc ~/.zshrc
ln -fs $CONFIG_ROOT/zsh/_p10k.zsh ~/.p10k.zsh
ln -fs $CONFIG_ROOT/zsh/alias.sh ~/.alias.sh
ln -fs $CONFIG_ROOT/zsh ~/.zsh
# ~/.extra.sh should be unique to every machine and should NOT be symlinked!
#ln -fs $CONFIG_ROOT/zsh/extra.sh ~/.extra.sh
