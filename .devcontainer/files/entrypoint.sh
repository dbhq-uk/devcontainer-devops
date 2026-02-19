#!/bin/bash
set -euo pipefail

# Copy defaults only if volume is empty
if [ ! -e /home/vscode/.initialized ]; then
    echo "Initializing vscode home directory..."
    cp -r /tmp-home/. /home/vscode/

    # Set git defaults once on first init (not on every shell startup)
    su - vscode -c 'git config --global core.editor nano'
    su - vscode -c 'git config --global pull.rebase false'
    su - vscode -c 'git config --global init.defaultBranch main'
    su - vscode -c 'git config --global color.ui auto'

    touch /home/vscode/.initialized
    chown -R vscode:vscode /home/vscode
fi

exec "$@"