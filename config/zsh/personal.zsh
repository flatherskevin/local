# Optional personal workflow additions for github.com/flatherskevin/local.
# Link this file into ~/.config/zsh/personal.zsh if you want these shortcuts.

# AWS
alias awsconfig='eval $EDITOR $HOME/.aws/config'
alias awscredentials='eval $EDITOR $HOME/.aws/credentials'
alias fixcreds='ssh-add -K $HOME/.ssh/id_rsa && ssh-add -K $HOME/.ssh/id_ed25519'

# Python
alias venvactivate='source .venv/bin/activate &> /dev/null || source venv/bin/activate &> /dev/null || true'
venvactivate
alias venvcreate='uv venv ./.venv'
alias venvall='venvcreate && venvactivate'
alias venvpytest='./.venv/bin/pytest --cache-clear'
alias venvpytestcov='pytest_coverage'
alias pyi='uv pip install -r requirements.txt'
alias pyfreeze='uv pip freeze > requirements.txt'

pytest_coverage() {
  venvpytest --cov=$1 --cov-report term-missing
}

# Golang
alias gotest='go test -gcflags=all=-l ./...'
alias gotestcov='gotest -coverprofile=coverage.out && go tool cover -html=coverage.out'

# Terraform
alias tf='terraform'
alias tfa='terraform apply --auto-approve'
alias tfp='terraform plan'
alias tfw='terraform workspace'
alias tfws='terraform workspace select'
alias tfwsn='tf_select_or_new'
alias tfwl='terraform workspace list'
alias tfd='terraform destroy'
alias tfi='terraform init'
alias tft='terraform taint'
alias tfr='terraform refresh'
alias tfrmi='(rm -rf .terraform || true) && tfi'

tf_select_or_new() {
  tfws $1 || tfw new $1
}

# Docker (colima)
export DOCKER_HOST='unix://$HOME/.colima/docker.sock'
alias dockerstart='colima start'
alias dockerstop='colima stop'
alias dockerkill='docker kill $(docker ps -a --format " {{.ID}}") || echo "No containers to kill"'
alias dockerrm='docker rm $(docker ps -a -q) || echo "No containers to delete"'
alias dockerrmi='docker rmi $(docker image ls -qa) -f || echo "No images to delete"'
alias dockervp='docker volume prune'
alias dockerkri='dockerkill && dockerrm && dockervp && dockerrmi'
