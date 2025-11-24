# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    docker
    kubectl
    terraform
    azure
    ansible
    python
    helm
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Load aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Load environment
if [ -f ~/.environment ]; then
    source ~/.environment
fi

# Terraform aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'

# Terragrunt aliases
alias tg='terragrunt'
alias tgi='terragrunt init'
alias tgp='terragrunt plan'
alias tga='terragrunt apply'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'

# Docker aliases  
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'

# Navigation
alias workspace='cd /workspace'

# Welcome message
echo "🚀 DevOps DevContainer (ZSH) Ready!"
