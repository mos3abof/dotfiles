#!/bin/bash
set -eux
set -o pipefail

TMUX_CONFIG_PATH=~/workspace/dotfiles/tmux/tmux.conf
SYMLINK_PATH=~/.tmux.conf
if [ ! -f $TMUX_CONFIG_PATH ]; then
  echo "config file does not exist" && exit
fi

mkdir -p ~/.tmux
if [ -L ${SYMLINK_PATH} ]; then
  unlink ${SYMLINK_PATH}
fi

ln -s ${TMUX_CONFIG_PATH} ${SYMLINK_PATH}
