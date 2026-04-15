#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=bootstrap/common.sh
source "${SCRIPT_DIR}/../bootstrap/common.sh"

ensure_dir "${HOME}/.config"
ensure_dir "${HOME}/.local/bin"
ensure_dir "${HOME}/.oh-my-zsh/custom/themes"

link_path "${REPO_ROOT}/config/nvim" "${HOME}/.config/nvim"
link_path "${REPO_ROOT}/config/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
link_path "${REPO_ROOT}/config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
link_path "${REPO_ROOT}/config/zsh/zshrc" "${HOME}/.config/zsh/zshrc"
link_path "${REPO_ROOT}/flatherskevin.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes/flatherskevin.zsh-theme"

link_path "${REPO_ROOT}/scripts/dev" "${HOME}/.local/bin/dev"
link_path "${REPO_ROOT}/scripts/cheat" "${HOME}/.local/bin/cheat"
link_path "${REPO_ROOT}/scripts/leaders" "${HOME}/.local/bin/leaders"

append_line_once "${HOME}/.zshrc" '[[ -f "$HOME/.config/zsh/zshrc" ]] && source "$HOME/.config/zsh/zshrc"'
