#!/bin/sh

# Get the required zsh plugins

# set MYZSHDIR if it is not set
MYZSHDIR=${MYZSHDIR:-$HOME/.zsh.d}

# make plugins directory
mkdir "$MYZSHDIR/plugins"

git clone https://github.com/zsh-users/zsh-syntax-highlighting $MYZSHDIR/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions $MYZSHDIR/plugins/zsh-autosuggestions

wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O $MYZSHDIR/plugins/git-prompt.sh