#!/bin/zsh

#          _                     
#  _______| |__   ___ _ ____   __
# |_  / __| '_ \ / _ \ '_ \ \ / /
#  / /\__ \ | | |  __/ | | \ V / 
# /___|___/_| |_|\___|_| |_|\_/  

### ZSH dirs
#
# Set where the rest of
# ZSH files are located
export ZDOTDIR="$HOME/.config/zsh"
#
# Set where ZSH
# cache files are stored
export ZCACHEDIR="$HOME/.cache/zsh"

### User settings
#
# Additional programs
export PATH=$PATH:$HOME/.local/share/bin:$HOME/.local/bin:$HOME/go/bin
#
# File Editor
export EDITOR=vim
#
# GO path
export GOPATH=$HOME/go
