#!/usr/bin/env bash

set -euo pipefail

if ! command -v nvim >/dev/null 2>&1; then
  printf '[dotfiles] error: nvim is not installed\n' >&2
  exit 1
fi

NVIM_APPNAME="${NVIM_APPNAME:-nvim}"
export NVIM_APPNAME

printf '[dotfiles] Syncing LazyVim and plugins\n'
nvim --headless "+Lazy! sync" +qa

printf '[dotfiles] Installing Mason tools\n'
nvim --headless "+MasonToolsInstallSync" +qa

printf '[dotfiles] Updating Treesitter parsers\n'
nvim --headless "+TSUpdate" +qa
