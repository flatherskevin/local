#!/usr/bin/env bash

set -euo pipefail

commands=(
  "./scripts/dev --help"
  "./scripts/cheat --help"
  "./scripts/leaders"
)

for command in "${commands[@]}"; do
  printf '[smoke] %s\n' "$command"
  eval "$command" >/dev/null
done
