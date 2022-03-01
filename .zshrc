ZSH_DISABLE_COMPFIX="true"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PYENV_SHELL="zsh"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_VERSION="3.9.10"
export PATH=/usr/local/git/bin:$PATH
export PATH=$HOME/.tfenv/bin:$PATH

source $HOME/.poetry/env || echo "poetry not installed"

if ! command -v code &> /dev/null
then
    alias code="nano"
    export EDITOR="nano"
else
    export EDITOR="code -w"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PAGER=

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

ZSH_THEME="flatherskevin"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias cls="tput reset"
alias awsconfig="code ~/.aws/config"
alias awscredentials="code ~/.aws/credentials"
alias fixcreds="ssh-add -K ~/.ssh/id_rsa && ssh-add -K ~/.ssh/id_ed25519"
alias codebase="cd ~/codebase"
alias localconfig="code ~/.localrc"

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
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    if [[ "$OSTYPE" = "linux-gnu"* ]]
    then
        os_install_package libssl-dev
    fi
    $HOME/.pyenv/bin/pyenv install 3.9.10
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
    pip install virtualenv
}

alias updatelocal="
    os_update
    os_install_package git && \
    os_install_package unzip && \
    os_install_python && \
    pip3 install virtualenv && \
    if [ ! -d ~/.tfenv ] ; then git clone https://github.com/tfutils/tfenv.git ~/.tfenv; else git -C ~/.tfenv pull ; fi && \
    os_install_aws_cli
"

# Zsh
alias reload="source ~/.zshrc"
alias zshconfig="code ~/.zshrc"
alias zshtheme="code ~/.oh-my-zsh/custom/themes/flatherskevin.zsh-theme"
alias zshupdaterc="curl https://raw.githubusercontent.com/flatherskevin/local/main/.zshrc -o ~/.zshrc"
alias zshupdatetheme="curl https://raw.githubusercontent.com/flatherskevin/local/main/flatherskevin.zsh-theme -o ~/.oh-my-zsh/custom/themes/flatherskevin.zsh-theme"
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

# Python
alias venvactivate="source .venv/bin/activate || source venv/bin/activate || echo \"\""
venvactivate
alias venvcreate="python3 -m virtualenv ./.venv"
alias venvpytest="./.venv/bin/pytest --cache-clear"
alias venvpytestcov="./.venv/bin/pytest --cache-clear --cov=nebula_utils --cov-report term-missing"
alias pyi="pip install -r requirements.txt -U"
alias pyfreeze="pip freeze > requirements.txt"

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

source ~/.localrc 2> /dev/null

# Golang
alias gotest="go test -gcflags=all=-l ./..."
alias gotestcov="gotest -coverprofile=coverage.out && go tool cover -html=coverage.out"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Docker (Optional)
# alias dockerkill="docker kill \$(docker ps -a --format \" {{.ID}}\")"
# alias dockerrm="docker rm $(docker ps -a -q)"
# alias dockerrmi="docker rmi $(docker image ls -qa)"
# alias dockerkri="dockerkill && dockerrm && dockerrmi"

export PATH=$HOME/.local/bin:$PATH
