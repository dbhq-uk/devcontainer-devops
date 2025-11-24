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

# Welcome message
echo "🚀 DevOps DevContainer (ZSH) Ready!"
