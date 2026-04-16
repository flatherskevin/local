#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${LOCAL_REPO_URL:-https://github.com/flatherskevin/local.git}"
INSTALL_BASE_DIR="${LOCAL_BASE_DIR:-$HOME/.flatherskevin}"
RELEASES_DIR="${LOCAL_RELEASES_DIR:-$INSTALL_BASE_DIR/releases}"
INSTALL_DIR="${LOCAL_INSTALL_DIR:-$INSTALL_BASE_DIR/local}"
INSTALL_REF="${LOCAL_INSTALL_REF:-main}"
RELEASE_NAME="${LOCAL_RELEASE_NAME:-$(date +%Y%m%d-%H%M%S)-$(printf '%s' "$INSTALL_REF" | tr '/ ' '--')}"
TEMP_RELEASE_DIR="${RELEASES_DIR}/${RELEASE_NAME}"
CURRENT_TARGET=""

cleanup() {
  if [[ -n "$TEMP_RELEASE_DIR" && -d "$TEMP_RELEASE_DIR/.git" ]] && [[ ! -f "$TEMP_RELEASE_DIR/.bootstrap-succeeded" ]]; then
    printf '[local] keeping failed release for inspection: %s\n' "$TEMP_RELEASE_DIR" >&2
  fi
}

trap cleanup EXIT

resolve_current_target() {
  if [[ -L "$INSTALL_DIR" ]]; then
    local target
    target="$(readlink "$INSTALL_DIR")"
    if [[ "$target" != /* ]]; then
      target="$(cd "$(dirname "$INSTALL_DIR")" && cd "$(dirname "$target")" && pwd)/$(basename "$target")"
    fi
    printf '%s\n' "$target"
    return 0
  fi

  if [[ -d "$INSTALL_DIR" ]]; then
    printf '%s\n' "$INSTALL_DIR"
  fi
}

activate_release() {
  local release_path="$1"
  local link_tmp="${INSTALL_DIR}.tmp"

  ln -sfn "$release_path" "$link_tmp"
  mv -f "$link_tmp" "$INSTALL_DIR"
}

cleanup_old_releases() {
  local keep_count=2
  local -a releases=()
  local release

  while IFS= read -r release; do
    releases+=("$release")
  done < <(find "$RELEASES_DIR" -mindepth 1 -maxdepth 1 -type d | sort -r)

  if [[ ${#releases[@]} -le $keep_count ]]; then
    return 0
  fi

  for release in "${releases[@]:$keep_count}"; do
    if [[ -n "$CURRENT_TARGET" && "$release" == "$CURRENT_TARGET" ]]; then
      continue
    fi
    printf '[local] pruning old release: %s\n' "$release"
    rm -rf "$release"
  done
}

migrate_legacy_install_dir() {
  if [[ -d "$INSTALL_DIR" && ! -L "$INSTALL_DIR" ]]; then
    local migrated_path
    migrated_path="${RELEASES_DIR}/legacy-$(date +%Y%m%d-%H%M%S)"
    printf '[local] migrating existing install dir to %s\n' "$migrated_path"
    mv "$INSTALL_DIR" "$migrated_path"
    CURRENT_TARGET="$migrated_path"
  fi
}

printf '[local] install dir: %s\n' "$INSTALL_DIR"

mkdir -p "$(dirname "$INSTALL_DIR")"
mkdir -p "$INSTALL_BASE_DIR"
mkdir -p "$RELEASES_DIR"

CURRENT_TARGET="$(resolve_current_target || true)"
migrate_legacy_install_dir

printf '[local] cloning %s (ref: %s)\n' "$REPO_URL" "$INSTALL_REF"
git clone --depth 1 --branch "$INSTALL_REF" "$REPO_URL" "$TEMP_RELEASE_DIR"

chmod +x "$TEMP_RELEASE_DIR/bootstrap/macos.sh" "$TEMP_RELEASE_DIR"/scripts/*.sh "$TEMP_RELEASE_DIR/scripts/dev"
"$TEMP_RELEASE_DIR/bootstrap/macos.sh"
touch "$TEMP_RELEASE_DIR/.bootstrap-succeeded"

activate_release "$TEMP_RELEASE_DIR"
cleanup_old_releases

printf '[local] active release: %s\n' "$TEMP_RELEASE_DIR"
