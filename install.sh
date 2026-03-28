#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${LOCAL_REPO_URL:-https://github.com/flatherskevin/local.git}"
INSTALL_DIR="${LOCAL_INSTALL_DIR:-$HOME/codebase/local}"

printf '[local] install dir: %s\n' "$INSTALL_DIR"

mkdir -p "$(dirname "$INSTALL_DIR")"

if [[ -d "$INSTALL_DIR/.git" ]]; then
  printf '[local] updating existing repo\n'
  git -C "$INSTALL_DIR" fetch origin --prune
  git -C "$INSTALL_DIR" pull --ff-only
else
  printf '[local] cloning repo\n'
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/bootstrap/macos.sh" "$INSTALL_DIR"/scripts/*.sh "$INSTALL_DIR/scripts/dev"
exec "$INSTALL_DIR/bootstrap/macos.sh"

