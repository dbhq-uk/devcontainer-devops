#!/bin/bash
set -e

# Copy defaults only if volume is empty
if [ ! -e /home/vscode/.initialized ]; then
    echo "Initializing vscode home directory..."
    cp -r /tmp-home/. /home/vscode/
    touch /home/vscode/.initialized
    chown -R vscode:vscode /home/vscode
fi

exec "$@"