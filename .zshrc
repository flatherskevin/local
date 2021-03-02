ZSH_DISABLE_COMPFIX="true"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/Library/Python/3.8/bin:$PATH
export PATH=/usr/local/git/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="code -w"
export PAGER=

ZSH_THEME="kflathers"

plugins=(git)

source $ZSH/oh-my-zsh.sh
# source venv/bin/activate || (echo "using env/" && source env/bin/activate)

alias cls="tput reset"
alias awsconfig="code ~/.aws/config"
alias awscredentials="code ~/.aws/credentials"
alias fixcreds="ssh-add -K ~/.ssh/id_rsa && ssh-add -K ~/.ssh/id_ed25519"
alias codebase="cd ~/codebase"
alias updatelocal="
    sudo apt update && \
    sudo apt -y upgrade && \
    sudo apt -y install git && \
    sudo apt -y install unzip && \
    sudo apt -y install python3 && \
    if [ ! -d ~/.tfenv ] ; then git clone https://github.com/tfutils/tfenv.git ~/.tfenv; else git -C ~/.tfenv pull ; fi && \
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && unzip -o awscliv2.zip && sudo ./aws/install
"

# Zsh
alias reload="source ~/.zshrc"
alias zshconfig="code ~/.zshrc"
alias zshtheme="code ~/.oh-my-zsh/custom/themes/kflathers.zsh-theme"
alias zshupdaterc="curl https://raw.githubusercontent.com/flatherskevin/local/main/.zshrc -o ~/.zshrc"
alias zshupdatetheme="curl https://raw.githubusercontent.com/flatherskevin/local/main/kflathers.zsh-theme -o ~/.oh-my-zsh/custom/themes/kflathers.zsh-theme"
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
alias gitc="git checkout"

# Python
alias pyenv="source venv/bin/activate"
alias pyenvcreate="python3 -m virtualenv venv"
alias pyi="pip install -r requirements.txt"
alias pyfreeze="pip freeze > requirements.txt"
alias venvpytest="./venv/bin/pytest --cache-clear"
alias venvpytestcov="./venv/bin/pytest --cache-clear --cov=nebula_utils --cov-report term-missing"

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
