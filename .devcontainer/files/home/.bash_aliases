# Terraform aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfo='terraform output'
alias tfs='terraform state'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfw='terraform workspace'

# Terragrunt aliases
alias tg='terragrunt'
alias tgi='terragrunt init'
alias tgp='terragrunt plan'
alias tga='terragrunt apply'
alias tgd='terragrunt destroy'
alias tgaa='terragrunt run-all apply'
alias tgpa='terragrunt run-all plan'
alias tgda='terragrunt run-all destroy'

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs'
alias dprune='docker system prune -a'
alias dstop='docker stop $(docker ps -q)'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'

# Helm aliases
alias h='helm'
alias hl='helm list'
alias hi='helm install'
alias hu='helm upgrade'
alias hd='helm delete'
alias hs='helm search'
alias hr='helm repo'

# Azure CLI aliases
alias azl='az login'
alias azls='az account list'
alias azs='az account set --subscription'
alias azg='az group'
alias azgl='az group list'
alias azvm='az vm'
alias azaks='az aks'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'
alias gl='git log --oneline --graph'
alias gd='git diff'

# Ansible aliases
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ai='ansible-inventory'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias workspace='cd /workspace'

# Python aliases
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'

# Utilities
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias myip='curl -s ifconfig.me'
alias ports='netstat -tulanp'
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias diskinfo='df -h'

# JSON/YAML processing
alias jqp='jq -C | less -R'
alias yqp='yq -C | less -R'

# Quick edits
alias bashrc='vim ~/.bashrc'
alias aliases='vim ~/.bash_aliases'

# Validation
alias validate='bash /workspace/devcontainer/tests/validate-tools.sh'
alias testall='bash /workspace/devcontainer/tests/run-all-tests.sh'