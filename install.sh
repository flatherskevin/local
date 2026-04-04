#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${LOCAL_REPO_URL:-https://github.com/flatherskevin/local.git}"
INSTALL_BASE_DIR="${LOCAL_BASE_DIR:-$HOME/.flatherskevin}"
INSTALL_DIR="${LOCAL_INSTALL_DIR:-$INSTALL_BASE_DIR/local}"
INSTALL_REF="${LOCAL_INSTALL_REF:-main}"
TEMP_DIR=""

cleanup() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
}

trap cleanup EXIT

printf '[local] install dir: %s\n' "$INSTALL_DIR"

mkdir -p "$(dirname "$INSTALL_DIR")"
mkdir -p "$INSTALL_BASE_DIR"

printf '[local] cloning %s (ref: %s)\n' "$REPO_URL" "$INSTALL_REF"
TEMP_DIR="$(mktemp -d "${INSTALL_BASE_DIR}/local.tmp.XXXXXX")"
git clone --depth 1 --branch "$INSTALL_REF" "$REPO_URL" "$TEMP_DIR"

rm -rf "$INSTALL_DIR"
mv "$TEMP_DIR" "$INSTALL_DIR"
TEMP_DIR=""

chmod +x "$INSTALL_DIR/bootstrap/macos.sh" "$INSTALL_DIR"/scripts/*.sh "$INSTALL_DIR/scripts/dev"
exec "$INSTALL_DIR/bootstrap/macos.sh"
