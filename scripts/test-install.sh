#!/usr/bin/env bash

set -euo pipefail

# Resolve repo root from this script's location so the test can be run from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

tests_run=0
tests_failed=0

check() {
  local label="$1" expected="$2" actual="$3"
  tests_run=$((tests_run + 1))
  if [[ "$expected" == "$actual" ]]; then
    printf '[pass] %s\n' "$label"
  else
    tests_failed=$((tests_failed + 1))
    printf '[FAIL] %s\n  expected: %q\n  actual:   %q\n' "$label" "$expected" "$actual"
  fi
}

sandbox="$(mktemp -d)"
trap 'rm -rf "$sandbox"' EXIT

# install.sh assigns its own path variables when sourced, so the sandbox has to
# be handed to it through the LOCAL_* environment overrides it reads.
export LOCAL_BASE_DIR="${sandbox}/base"

# shellcheck source=install.sh
source "${REPO_ROOT}/install.sh"

# The tests below delete directories, so refuse to run against a real install.
for resolved in "$INSTALL_DIR" "$RELEASES_DIR"; do
  if [[ "$resolved" != "${sandbox}/"* ]]; then
    printf 'test-install: refusing to run; %s escaped the sandbox\n' "$resolved" >&2
    exit 1
  fi
done

mkdir -p "${RELEASES_DIR}/old" "${RELEASES_DIR}/new"

# --- activate_release with no pointer yet ---
activate_release "${RELEASES_DIR}/new"
check "activate_release creates the pointer" "${RELEASES_DIR}/new" "$(readlink "$INSTALL_DIR")"

# --- activate_release over a pointer that already targets a release directory ---
activate_release "${RELEASES_DIR}/old"
activate_release "${RELEASES_DIR}/new"
check "activate_release advances an existing pointer" "${RELEASES_DIR}/new" "$(readlink "$INSTALL_DIR")"
check "activate_release leaves nothing inside the superseded release" "" "$(ls -A "${RELEASES_DIR}/old")"
check "resolve_current_target follows the advanced pointer" "${RELEASES_DIR}/new" "$(resolve_current_target)"

# --- a correct pointer lets pruning retire old releases instead of pinning them ---
rm -rf "${RELEASES_DIR:?}"/*
mkdir -p "${RELEASES_DIR}/20260101-000000-main" \
  "${RELEASES_DIR}/20260201-000000-main" \
  "${RELEASES_DIR}/20260301-000000-main"
activate_release "${RELEASES_DIR}/20260301-000000-main"
CURRENT_TARGET="$(resolve_current_target)"
cleanup_old_releases >/dev/null
remaining="$(find "$RELEASES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | paste -sd, -)"
check "cleanup_old_releases retires releases the pointer no longer names" \
  "20260201-000000-main,20260301-000000-main" "$remaining"
check "cleanup_old_releases keeps the live release" \
  "${RELEASES_DIR}/20260301-000000-main" "$(resolve_current_target)"

printf '\n%d run, %d failed\n' "$tests_run" "$tests_failed"
[[ "$tests_failed" -eq 0 ]]
