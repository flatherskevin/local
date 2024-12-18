ZSH_DISABLE_COMPFIX="true"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PYENV_SHELL="zsh"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PATH=/usr/local/git/bin:$PATH
export PATH=$HOME/.tfenv/bin:$PATH
export PATH=./node_modules/.bin:$PATH
export PATH=$HOME/linuxbrew/.linuxbrew/bin/brew:$PATH

source $HOME/.poetry/env &> /dev/null || true

export EDITOR="code -w"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PAGER=
ZSH_THEME="flatherskevin"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias cls="tput reset"
alias awsconfig="eval $EDITOR $HOME/.aws/config"
alias awscredentials="eval $EDITOR $HOME/.aws/credentials"
alias fixcreds="ssh-add -K $HOME/.ssh/id_rsa && ssh-add -K $HOME/.ssh/id_ed25519"
alias codebase="cd $HOME/codebase"
alias localconfig="eval $EDITOR $HOME/.localrc"

function os_install_package() {
    if [[ "$OSTYPE" = "darwin"* ]]
    then
        brew install $@ || brew upgrade $@
    elif [[ "$OSTYPE" = "linux-gnu"* ]]
    then
        sudo apt -y install $@
    fi
}

function os_update() {
    if [[ "$OSTYPE" = "darwin"* ]]
    then
        brew update && brew upgrade
    elif [[ "$OSTYPE" = "linux-gnu"* ]]
    then
        sudo apt update && sudo apt -y upgrade
    fi
}

function os_install_aws_cli() {
    if [[ "$OSTYPE" = "darwin"* ]]
    then
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o $HOME/AWSCLIV2.pkg && sudo installer -pkg $HOME/AWSCLIV2.pkg -target /
    elif [[ "$OSTYPE" = "linux-gnueabihf"* ]]
    then
        pip install git+git://github.com/aws/aws-cli.git@2.3.6
    elif [[ "$OSTYPE" = "linux-gnu"* ]]
    then
        curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o $HOME/awscliv2.zip && unzip $HOME/awscliv2.zip -d $HOME/aws/ && sudo $HOME/aws/install --update
    fi
}

function os_install_python() {
    curl -LsSf https://astral.sh/uv/install.sh | sh
    uv python install 3.12
}

function install_nodejs() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 20.11.1
    npm i -g corepack
}

alias updatelocal="
    os_update
    os_install_package git && \
    os_install_package unzip && \
    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && \
    os_install_python && \
    pip3 install virtualenv && \
    install_nodejs && \
    if [ ! -d $HOME/.tfenv ] ; then git clone https://github.com/tfutils/tfenv.git $HOME/.tfenv; else git -C $HOME/.tfenv pull ; fi && \
    os_install_aws_cli
"

# Zsh
alias reload="source $HOME/.zshrc"
alias zshconfig="eval $EDITOR $HOME/.zshrc"
alias zshtheme="eval $EDITOR $HOME/.oh-my-zsh/custom/themes/flatherskevin.zsh-theme"
alias zshupdaterc="curl https://raw.githubusercontent.com/flatherskevin/local/main/.zshrc -o $HOME/.zshrc"
alias zshupdatetheme="curl https://raw.githubusercontent.com/flatherskevin/local/main/flatherskevin.zsh-theme -o $HOME/.oh-my-zsh/custom/themes/flatherskevin.zsh-theme"
alias zshupdate="zshupdaterc && zshupdatetheme && reload"

# Git
alias gitac="git add . && git commit -m"
alias gitmasterp="git checkout master && git pull"
alias gitmainp="git checkout main && git pull"
alias gitpu="git branch --show-current | xargs -I {} git push -u origin {}"
alias gitb="git checkout -b"
alias gitlog="git log --oneline"
alias gitrebmaster="gitmasterp && git checkout - && git rebase master"
alias gitrebmain="gitmainp && git checkout - && git rebase main"
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

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Docker (Optional)
alias dockerkill="docker kill \$(docker ps -a --format ' {{.ID}}') || echo 'No containers to kill' "
alias dockerrm="docker rm \$(docker ps -a -q) || echo 'No containers to delete'"
alias dockerrmi="docker rmi \$(docker image ls -qa) -f || echo 'No images to delete'"
alias dockervp="docker volume prune"
alias dockerkri="dockerkill && dockerrm && dockervp && dockerrmi"

export PATH=$HOME/.local/bin:$PATH
