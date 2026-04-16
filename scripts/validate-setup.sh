#!/usr/bin/env bash

set -euo pipefail

required_commands=(
  fd
  fzf
  git
  go
  kitty
  lazygit
  nvim
  node
  rg
  terraform
  tflint
  tmux
  tmuxp
  uv
  yq
)

optional_commands=(
  claude
  codex
  colima
  docker
)

status=0

check_commands() {
  local label="$1"
  shift
  local cmd

  printf '[dotfiles] %s\n' "$label"
  for cmd in "$@"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      printf '[ok] %s\n' "$cmd"
    else
      printf '[missing] %s\n' "$cmd" >&2
      if [[ "$label" == "Required tools" ]]; then
        status=1
      fi
    fi
  done
}

check_commands "Required tools" "${required_commands[@]}"
check_commands "Optional tools" "${optional_commands[@]}"

if nvim --headless "+quitall" >/dev/null 2>&1; then
  printf '[ok] Neovim starts cleanly\n'
else
  printf '[missing] Neovim failed to start cleanly\n' >&2
  status=1
fi

tmux_validation_session="__local_validate__"
if tmux new-session -d -s "$tmux_validation_session" >/dev/null 2>&1 \
  && tmux source-file "${HOME}/.config/tmux/tmux.conf" >/dev/null 2>&1; then
  printf '[ok] tmux config loads cleanly\n'
else
  printf '[missing] tmux config failed to load\n' >&2
  status=1
fi
tmux kill-session -t "$tmux_validation_session" >/dev/null 2>&1 || true

if [[ "$status" -ne 0 ]]; then
  printf '[dotfiles] validation failed\n' >&2
  exit "$status"
fi

printf '[dotfiles] validation passed\n'
