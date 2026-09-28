#!/usr/bin/env bash

set -euo pipefail

# Resolve repo root from this script's location so the test can be run from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
THEME="${REPO_ROOT}/config/omp/themes/flatherskevin.json"

if ! command -v jq >/dev/null 2>&1; then
  printf 'jq is required but not installed\n' >&2
  exit 1
fi

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

# omp resolves a color token through `vars` until it reaches a hex string, a
# 256-color index, or "" (terminal default). Anything else is a dangling
# reference, which makes omp reject the theme and silently fall back to `dark`.
resolve() {
  jq -r --arg token "$1" '
    def resolve($value; $depth):
      if $depth > 16 then "CYCLE"
      elif ($value | test("^#[0-9a-fA-F]{6}$")) or ($value == "") or ($value | test("^[0-9]+$")) then $value
      elif (.vars | has($value)) then resolve(.vars[$value]; $depth + 1)
      else "UNRESOLVED:" + $value
      end;
    resolve(.colors[$token]; 0)
  ' "$THEME"
}

check "theme file is valid JSON" "0" "$(
  jq -e . "$THEME" >/dev/null 2>&1
  printf '%s' "$?"
)"
check "theme name matches its filename" "flatherskevin" "$(jq -r '.name' "$THEME")"

unresolved="$(
  jq -r '
    def resolve($value; $depth):
      if $depth > 16 then "CYCLE"
      elif ($value | test("^#[0-9a-fA-F]{6}$")) or ($value == "") or ($value | test("^[0-9]+$")) then "OK"
      elif (.vars | has($value)) then resolve(.vars[$value]; $depth + 1)
      else "UNRESOLVED"
      end;
    [(.colors | keys[]) as $k | select(resolve(.colors[$k]; 0) != "OK") | $k] | join(",")
  ' "$THEME"
)"
check "every color token resolves through vars" "" "$unresolved"

# The whole point of forking titanium: typed input must not share a surface with
# tool blocks or the status line, which titanium renders in one shared color.
user_bg="$(resolve userMessageBg)"
check "user surface is a concrete color" "#1a3347" "$user_bg"
for token in toolPendingBg toolSuccessBg toolErrorBg statusLineBg customMessageBg; do
  other="$(resolve "$token")"
  if [[ "$other" == "$user_bg" ]]; then
    check "user surface differs from ${token}" "different" "same (${other})"
  else
    check "user surface differs from ${token}" "different" "different"
  fi
done

# Typed text reads brighter than tool output rather than inheriting terminal default.
user_text="$(resolve userMessageText)"
check "typed text has an explicit color" "#e8ecf4" "$user_text"
if [[ "$user_text" == "$(resolve toolOutput)" ]]; then
  check "typed text differs from tool output" "different" "same"
else
  check "typed text differs from tool output" "different" "different"
fi

printf '\n%d run, %d failed\n' "$tests_run" "$tests_failed"
[[ "$tests_failed" -eq 0 ]]
