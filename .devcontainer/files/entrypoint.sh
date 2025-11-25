#!/bin/bash
set -e

# Copy defaults only if volume is empty
if [ ! -e /home/vscode/.initialized ]; then
    echo "Initializing vscode home directory..."
    cp -r /tmp-home/. /home/vscode/
    touch /home/vscode/.initialized
    chown -R vscode:vscode /home/vscode
fi

# Fix hostname resolution for sudo
HOSTNAME=$(hostname)
if ! grep -q "$HOSTNAME" /etc/hosts; then
    echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
fi

exec "$@"