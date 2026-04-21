ZSH_DISABLE_COMPFIX="true"

export EDITOR="code -w"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

# Path to your oh-my-zsh installation.
export PAGER=
ZSH_THEME="flatherskevin"
plugins=(git)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

alias cls="tput reset"
alias awsconfig="eval $EDITOR $HOME/.aws/config"
alias awscredentials="eval $EDITOR $HOME/.aws/credentials"
alias fixcreds="ssh-add -K $HOME/.ssh/id_rsa && ssh-add -K $HOME/.ssh/id_ed25519"
alias codebase="cd $HOME/codebase"
alias localconfig="eval $EDITOR $HOME/.localrc"
alias bash="/opt/homebrew/bin/bash"
alias awake="caffeinate -disu"
alias onedisplay="displayplacer 'id:2 enabled:false' || displayplacer 'id:3 enabled:false'"
alias c="eval $EDITOR"

local_repo="${HOME}/codebase/local"

update_local_env() {
    if [[ -x "${local_repo}/install.sh" ]]; then
        "${local_repo}/install.sh"
    else
        curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
    fi
}

alias updatelocal="update_local_env"

# Zsh
alias reload="source $HOME/.zshrc"
alias zshconfig="eval $EDITOR $HOME/.zshrc"
alias zshtheme="eval $EDITOR $HOME/.oh-my-zsh/custom/themes/flatherskevin.zsh-theme"

# Git
alias gitac="git add . && git commit -m"
alias gitdevp="git checkout develop && git pull"
alias gitmasterp="git checkout master && git pull"
alias gitmainp="git checkout main && git pull"
alias gitpu="git branch --show-current | xargs -I {} git push -u origin {}"
alias gitb="git checkout -b"
alias gitlog="git log --oneline"
alias gitrebmaster="gitdevp && git checkout - && git rebase develop"
alias gitrebmaster="gitmasterp && git checkout - && git rebase master"
alias gitrebmain="gitmainp && git checkout - && git rebase main"
alias gitrebidev="gitdevp && git checkout - && git rebase -i develop"
alias gitrebimaster="gitmasterp && git checkout - && git rebase -i master"
alias gitrebimain="gitmainp && git checkout - && git rebase -i main"
alias gitreba="git rebase --abort"
alias gitrebc="git rebase --continue"
alias gitc="git checkout"
alias gitacfix="gitac \"Fixes per PR\" && gitpu"
alias gitfc="git fetch && gitc"

# Python
alias venvactivate="source .venv/bin/activate &> /dev/null || source venv/bin/activate &> /dev/null || true"
venvactivate
alias venvcreate="uv venv ./.venv"
alias venvall="venvcreate && venvactivate"
alias venvallnew="rm -rf ./.venv && venvall"
alias venvpytest="./.venv/bin/pytest --cache-clear"
alias venvpytestcov="pytest_coverage"
alias pyi="uv pip install -r requirements.txt"
alias pyfreeze="uv pip freeze > requirements.txt"

pytest_coverage(){
    venvpytest --cov=$1 --cov-report term-missing
}

# Terraform
alias tf="terraform"
alias tfa="terraform apply --auto-approve"
alias tfp="terraform plan"
alias tfw="terraform workspace"
alias tfws="terraform workspace select"
alias tfwsn="tf_select_or_new"
alias tfwl="terraform workspace list"
alias tfd="terraform destroy"
alias tfi="terraform init"
alias tft="terraform taint"
alias tfr="terraform refresh"
alias tfrmi="(rm -rf .terraform || true) && tfi"

tf_select_or_new() {
    tfws $1 || tfw new $1
}

source $HOME/.localrc 2> /dev/null

# Golang
alias gotest="go test -gcflags=all=-l ./..."
alias gotestcov="gotest -coverprofile=coverage.out && go tool cover -html=coverage.out"

# Docker (Optional)
alias dockerkill="docker kill \$(docker ps -a --format ' {{.ID}}') || echo 'No containers to kill' "
alias dockerrm="docker rm \$(docker ps -a -q) || echo 'No containers to delete'"
alias dockerrmi="docker rmi \$(docker image ls -qa) -f || echo 'No images to delete'"
alias dockervp="docker volume prune"
alias dockerkri="dockerkill && dockerrm && dockervp && dockerrmi"

# AWS
alias whoamiaws='aws sts get-caller-identity'
alias awsrmcache="rm -rf $HOME/.aws/cache && rm -rf $HOME/.aws/cli && rm -rf $HOME/.aws/sso"

# Terminal-first Neovim workflow additions live in a separate file so this
# long-standing shell config can stay the primary entrypoint.
[[ -f "$HOME/.config/zsh/workflow.zsh" ]] && source "$HOME/.config/zsh/workflow.zsh"
