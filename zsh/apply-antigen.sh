#!/usr/bin/env zsh
# this script should be used in both one-time build and .zshrc

# disable logging, because it takes significant time if the log file is on NFS
# this value defaults to ~/.antigen/debug.log
export ANTIGEN_DEBUG_LOG=/dev/null

source $HOME/.antigen.zsh

plugins=(
  colorize
  command-not-found
  cp
  extract
  safe-paste
  history
  git
  docker
  npm
  node
  pip
  themes
  vi-mode
  web-search
  z
)
#  zsh-interactive-cd


antigen use oh-my-zsh

for repo in $plugins
do
    antigen bundle $repo
done

# WARNING: history-substring-highlighting must be _after_ syntax-highlighting
# otherwise history won't highlight
for repo in autosuggestions completions syntax-highlighting history-substring-search
do
    antigen bundle zsh-users/zsh-$repo
done
antigen bundle andrewferrier/fzf-z
# cd with fzf: https://github.com/b4b4r07/enhancd
antigen bundle b4b4r07/enhancd
antigen bundle b4b4r07/zsh-vimode-visual

antigen theme robbyrussell
# Tell Antigen that you're done.
antigen apply

# applying powerlevel10k will invoke the config wizard, which is annoying
# just install manually
#antigen theme romkatv/powerlevel10k
[ ! -d $HOME/.antigen/bundles/powerlevel10k ] && \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.antigen/bundles/powerlevel10k

# have to manually activate this plugin
source $HOME/.antigen/bundles/b4b4r07/enhancd/init.sh
