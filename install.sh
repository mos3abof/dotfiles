#!/usr/bin/env bash

set -x
set -o nounset
set -o errexit

if [[ "$(uname)" == "Darwin" ]]; then
  READLINK=greadlink
  LN=gln
else
  READLINK=readlink
  LN=ln
fi

# Assumptions are made that the dotfiles directory is residing under $HOME, in order to provide
# relative symlinks
#if [[ -z "$($READLINK -f $0 | grep $HOME)" ]]; then
#  echo "$($READLINK -f $0) must reside under $HOME"
#  exit 1
#fi

command_exists () {
  type "$1" &> /dev/null ;
}

# Check for binaries on PATH that are required for installation of plugins
if ! command_exists git || ! command_exists vim || ! command_exists test
then
  echo "Install git, vim and test, then re-execute this script"
  exit 1
fi

CURRENT_DIRECTORY=$(pwd)


# Confiture bash
#$CURRENT_DIRECTORY/bash/install.sh

# Configure vim
#IM_SCRIPT_EXISTS=$(test -f "$HOME/dotfiles/vim/install.sh")
#if [ $VIM_SCRIPT_EXITST  ]; then
  $CURRENT_DIRECTORY/vim/install.sh
#else
#  echo "Skipping vim installation. Didn'Vt find file"
#fi

# Configure tmux
#IM_SCRIPT_EXISTS=$(test -f "$HOME/dotfiles/vim/install.sh")
#if [ $VIM_SCRIPT_EXITST  ]; then
  $CURRENT_DIRECTORY/tmux/install.sh
#else
#  echo "Skipping vim installation. Didn'Vt find file"
#fi


# Congigure brew if Mac


# Install packages if Debian based
