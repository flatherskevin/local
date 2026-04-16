#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC2034
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOCAL_HOME="${LOCAL_BASE_DIR:-${HOME}/.flatherskevin}"
BACKUP_DIR="${LOCAL_HOME}/backups/$(date +%Y%m%d-%H%M%S)"

log() {
  printf '[dotfiles] %s\n' "$*"
}

warn() {
  printf '[dotfiles] warning: %s\n' "$*" >&2
}

die() {
  printf '[dotfiles] error: %s\n' "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_dir() {
  mkdir -p "$1"
}

backup_target() {
  local target="$1"

  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$2" ]]; then
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    ensure_dir "$BACKUP_DIR"
    local backup_name
    backup_name="${BACKUP_DIR}/$(basename "$target")"
    log "Backing up ${target} -> ${backup_name}"
    mv "$target" "$backup_name"
  fi
}

link_path() {
  local source_path="$1"
  local target_path="$2"

  ensure_dir "$(dirname "$target_path")"
  backup_target "$target_path" "$source_path"
  ln -sfn "$source_path" "$target_path"
  log "Linked ${target_path} -> ${source_path}"
}

append_line_once() {
  local file_path="$1"
  local line="$2"

  touch "$file_path"
  if ! grep -Fqx "$line" "$file_path"; then
    printf '\n%s\n' "$line" >>"$file_path"
    log "Updated ${file_path}"
  fi
}
