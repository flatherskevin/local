#!/usr/bin/env bash

set -euo pipefail

if ! command -v shellcheck >/dev/null 2>&1; then
  printf 'shellcheck is required but not installed\n' >&2
  exit 1
fi

shell_files=()
while IFS= read -r shell_file; do
  shell_files+=("$shell_file")
done < <(
  {
    printf '%s\n' install.sh
    find bootstrap scripts -type f \
      \( -name '*.sh' -o -path 'scripts/dev' -o -path 'scripts/cheat' -o -path 'scripts/leaders' \)
  } | sort -u
)

shellcheck "${shell_files[@]}"
