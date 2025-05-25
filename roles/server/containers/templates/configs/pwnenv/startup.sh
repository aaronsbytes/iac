#!/bin/bash

# Set environment variables
export USER={{ pwnenv.user.username }}
export HOME=/home/$USER
export DISPLAY=:1

# Ensure .vnc directory exists
mkdir -p $HOME/.vnc
chown -R $USER:$USER $HOME/.vnc

# Start ssh server
service ssh start &

# Start VNC server
su - $USER -c "vncserver $DISPLAY -geometry 1366x768 -depth 24"

# Prevent container from exiting
tail -f /dev/null
