#!/bin/bash

# Start code-server
su - coder -c "code-server" &

# Start Wetty
wetty --port 3000 --base /wetty &

# Start nginx
nginx -g "daemon off;"