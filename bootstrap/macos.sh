#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=bootstrap/common.sh
source "${SCRIPT_DIR}/common.sh"

if [[ "$(uname -s)" != "Darwin" ]]; then
  die "bootstrap/macos.sh must be run on macOS"
fi

if ! xcode-select -p >/dev/null 2>&1; then
  warn "Xcode Command Line Tools are required. Installing them now."
  xcode-select --install || true
  warn "If the installer opened a dialog, finish it and re-run this script."
  exit 1
fi

if ! command_exists brew; then
  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

log "Installing Homebrew packages"
brew bundle --file "${REPO_ROOT}/Brewfile"

if [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
  log "Enabling fzf shell integration"
  "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish --no-update-rc
fi

log "Linking configs and helper scripts"
"${REPO_ROOT}/scripts/link-configs.sh"

log "Installing Neovim plugins, parsers, and Mason-managed tools"
"${REPO_ROOT}/scripts/install-neovim-stack.sh"

log "Running validation checks"
"${REPO_ROOT}/scripts/validate-setup.sh"

log "Bootstrap complete"
log "Open a new shell or run: source ~/.zshrc"

