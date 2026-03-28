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

prepare_kitty_install() {
  local current_version expected_version

  if [[ ! -d /Applications/kitty.app ]]; then
    return 0
  fi

  if brew list --cask kitty >/dev/null 2>&1; then
    return 0
  fi

  current_version="$(
    /usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' \
      /Applications/kitty.app/Contents/Info.plist 2>/dev/null || true
  )"
  expected_version="$(brew info --cask kitty | awk 'NR==1 { sub(":", "", $2); print $2 }')"

  if [[ -z "$current_version" || -z "$expected_version" || "$current_version" == "$expected_version" ]]; then
    return 0
  fi

  ensure_dir "$BACKUP_DIR"
  log "Backing up existing kitty.app ${current_version} before Homebrew installs ${expected_version}"
  mv /Applications/kitty.app "${BACKUP_DIR}/kitty.app"
}

prepare_kitty_install
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
