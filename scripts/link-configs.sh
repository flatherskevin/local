#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=bootstrap/common.sh
source "${SCRIPT_DIR}/../bootstrap/common.sh"

ensure_dir "${HOME}/.config"
ensure_dir "${HOME}/.local/bin"

link_path "${REPO_ROOT}/config/nvim" "${HOME}/.config/nvim"
link_path "${REPO_ROOT}/config/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
link_path "${REPO_ROOT}/config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
link_path "${REPO_ROOT}/config/zsh/workflow.zsh" "${HOME}/.config/zsh/workflow.zsh"

link_path "${REPO_ROOT}/scripts/dev" "${HOME}/.local/bin/dev"
link_path "${REPO_ROOT}/scripts/cheat" "${HOME}/.local/bin/cheat"

append_line_once "${HOME}/.zshrc" '[[ -f "$HOME/.config/zsh/workflow.zsh" ]] && source "$HOME/.config/zsh/workflow.zsh"'

