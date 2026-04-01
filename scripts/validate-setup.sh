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
  uv
  yq
)

status=0

for cmd in "${required_commands[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[ok] %s\n' "$cmd"
  else
    printf '[missing] %s\n' "$cmd" >&2
    status=1
  fi
done

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
