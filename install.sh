#!/usr/bin/env bash
# Symlinks the configs listed in install.mapping into $HOME. Works on macOS and
# Linux, from wherever the repo is cloned, and is safe to re-run: links that
# already point at the repo are left alone, and anything else in the way is
# moved to ~/.dotfiles-bak-<timestamp>/ first.
#
# Packages are not installed here (see brew/ and dnf/).

set -o nounset -o errexit -o pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-bak-$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTFILES/$1" dest="$HOME/$2"

  if [[ ! -e "$src" ]]; then
    echo "skip    ~/$2 ($1 not in repo)"
    return
  fi
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok      ~/$2"
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$(dirname "$BACKUP_DIR/$2")"
    mv "$dest" "$BACKUP_DIR/$2"
    echo "backup  ~/$2 -> $BACKUP_DIR/$2"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "link    ~/$2 -> $1"
}

while IFS=: read -r src dest; do
  [[ -z "$src" || "$src" == \#* ]] && continue
  link "$src" "$dest"
done < "$DOTFILES/install.mapping"

# tmux plugin manager; press `prefix + I` inside tmux to install the plugins.
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [[ ! -e "$HOME/.gitconfig.local" ]]; then
  echo "note    no ~/.gitconfig.local; put machine-specific git settings (credential helpers) there"
fi
