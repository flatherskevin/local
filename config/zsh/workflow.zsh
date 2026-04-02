export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$PATH"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height=60% --layout=reverse --border'

alias v='nvim'
alias vim='nvim'
alias lg='lazygit'
alias tl='tmux ls'
alias ta='tmux attach -t'
alias tk='tmux ls -F "#{session_name}" | fzf --prompt="Kill session > " --height=50% --layout=reverse --border | xargs -I{} tmux kill-session -t {}'
alias dev='~/.local/bin/dev'
alias cheat='~/.local/bin/cheat'
alias keys='cheat'

workon() {
  dev "$@"
}

if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$(brew --prefix fzf 2>/dev/null)"
  if [[ -n "$FZF_PREFIX" ]]; then
    [[ -f "${FZF_PREFIX}/shell/completion.zsh" ]] && source "${FZF_PREFIX}/shell/completion.zsh"
    [[ -f "${FZF_PREFIX}/shell/key-bindings.zsh" ]] && source "${FZF_PREFIX}/shell/key-bindings.zsh"
  fi
fi

unset FZF_PREFIX

