#!/usr/bin/env bash

set -euo pipefail

# Resolve repo root from this script's location so the test can be run from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/dev
source "${SCRIPT_DIR}/dev"

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

check_status() {
  local label="$1" expected_status="$2"
  shift 2
  local actual_status=0
  "$@" >/dev/null 2>&1 || actual_status=$?
  tests_run=$((tests_run + 1))
  if [[ "$expected_status" -eq "$actual_status" ]]; then
    printf '[pass] %s\n' "$label"
  else
    tests_failed=$((tests_failed + 1))
    printf '[FAIL] %s\n  expected status: %s\n  actual status:   %s\n' "$label" "$expected_status" "$actual_status"
  fi
}

# --- companion_name ---
check "companion_name basic" "repo-56e811+1" "$(companion_name "repo-56e811" 1)"
check "companion_name two digit" "repo-56e811+12" "$(companion_name "repo-56e811" 12)"

# --- parent_of_session ---
check "parent_of_session strips suffix" "repo-56e811" "$(parent_of_session "repo-56e811+3")"
check "parent_of_session passthrough" "repo-56e811" "$(parent_of_session "repo-56e811")"
check "parent_of_session two-digit suffix" "repo-56e811" "$(parent_of_session "repo-56e811+10")"

# --- companions_of + next_companion_slot (stub list_sessions) ---
list_sessions() {
  printf '%s\n' "repo-56e811" "repo-56e811+1" "repo-56e811+3" "other-abc123" "other-abc123+1"
}
check "companions_of filters to parent" "repo-56e811+1
repo-56e811+3" "$(companions_of "repo-56e811")"
check "next_companion_slot fills gap" "2" "$(next_companion_slot "repo-56e811")"
check "next_companion_slot first free" "2" "$(next_companion_slot "other-abc123")"

# --- parse_picker_selection (use $'\t' so the tab is unambiguous) ---
check "parse_picker_selection NEW" "NEW" "$(parse_picker_selection $'NEW\t* New companion (+3)')"
check "parse_picker_selection name" "repo-56e811+1" "$(parse_picker_selection $'repo-56e811+1\t+1 . 4 panes')"
check "parse_picker_selection empty" "" "$(parse_picker_selection "")"

# --- session_list_command groups companions directly under their parent ---
list_sessions() { printf '%s\n' "repo-56e811+2" "other-abc123" "repo-56e811" "repo-56e811+1"; }
group_expected="other-abc123
repo-56e811
repo-56e811+1
repo-56e811+2"
check "session_list_command groups companions" "$group_expected" "$(session_list_command)"

list_sessions() { printf '%s\n' "repo-56e811"; }
check "next_companion_slot none used" "1" "$(next_companion_slot "repo-56e811")"

# --- create_companion_session (tmux-backed; skipped without tmux) ---
if command -v tmux >/dev/null 2>&1; then
  test_parent="devmoretest-$$"
  test_companion="${test_parent}+1"
  test_dir="$(mktemp -d)"
  # Ensure cleanup even on failure.
  trap 'tmux kill-session -t "$test_companion" 2>/dev/null || true; rm -rf "$test_dir"' EXIT

  create_companion_session "$test_companion" "$test_dir" 4

  pane_count="$(tmux list-panes -t "${test_companion}:1" 2>/dev/null | wc -l | tr -d ' ')"
  check "create_companion_session pane count" "4" "$pane_count"

  # A 4-pane tiled layout is always a 2x2 grid: two distinct column offsets and
  # two distinct row offsets. A wrong layout (e.g. main-vertical) would give 3 rows.
  distinct_left="$(tmux list-panes -t "${test_companion}:1" -F '#{pane_left}' 2>/dev/null | sort -u | wc -l | tr -d ' ')"
  distinct_top="$(tmux list-panes -t "${test_companion}:1" -F '#{pane_top}' 2>/dev/null | sort -u | wc -l | tr -d ' ')"
  check "create_companion_session tiled 2x2 (2 columns)" "2" "$distinct_left"
  check "create_companion_session tiled 2x2 (2 rows)" "2" "$distinct_top"

  first_pane_path="$(tmux display-message -p -t "${test_companion}:1.1" '#{pane_current_path}')"
  # macOS reports the mktemp dir through its /private symlink; normalize both sides.
  check "create_companion_session cwd" "$(cd "$test_dir" && pwd -P)" "$(cd "$first_pane_path" && pwd -P)"

  tmux kill-session -t "$test_companion" 2>/dev/null || true
  rm -rf "$test_dir"
  trap - EXIT
else
  printf '[skip] create_companion_session (tmux not available)\n'
fi

# --- regression: `dev session kill` with parent AND companion listed together
#     must succeed (exit 0) with no false "No tmux session named" error.
if command -v tmux >/dev/null 2>&1; then
  kp="devmorekilltest-$$"
  tmux new-session -d -s "$kp" -c "$HOME" 2>/dev/null
  tmux new-session -d -s "${kp}+1" -c "$HOME" 2>/dev/null
  tmux new-session -d -s "${kp}+2" -c "$HOME" 2>/dev/null
  trap 'for s in "$kp" "${kp}+1" "${kp}+2"; do tmux kill-session -t "$s" 2>/dev/null || true; done' EXIT

  kill_rc=0
  kill_out="$("${SCRIPT_DIR}/dev" session kill -s "$kp" -s "${kp}+1" 2>&1)" || kill_rc=$?
  check "session kill parent+companion exits 0" "0" "$kill_rc"
  check "session kill parent+companion no false error" "" "$(printf '%s\n' "$kill_out" | grep 'No tmux session named' || true)"
  check_status "session kill cascaded +2 also gone" 1 tmux has-session -t "${kp}+2"

  for s in "$kp" "${kp}+1" "${kp}+2"; do tmux kill-session -t "$s" 2>/dev/null || true; done
  trap - EXIT
else
  printf '[skip] session kill parent+companion regression (tmux not available)\n'
fi

printf '\n%d run, %d failed\n' "$tests_run" "$tests_failed"
[[ "$tests_failed" -eq 0 ]]
