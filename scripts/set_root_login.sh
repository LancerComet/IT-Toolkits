#!/bin/bash

# Script to enable or disable root user SSH login on Ubuntu systems.
# Usage: ./set_root_login.sh on  -- to enable root SSH login
#        ./set_root_login.sh off -- to disable root SSH login

# Define the SSH config file path
SSH_CONFIG="/etc/ssh/sshd_config"

# Check if the user provided either "on" or "off"
if [ "$1" == "on" ]; then
    # Enabling root SSH login
    echo "Enabling root SSH login..."
    # Use sed to either update or add the PermitRootLogin line
    sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' $SSH_CONFIG
    # Restart SSH service to apply changes
    sudo systemctl restart sshd
    echo "Root SSH login enabled."

elif [ "$1" == "off" ]; then
    # Disabling root SSH login
    echo "Disabling root SSH login..."
    # Use sed to either update or add the PermitRootLogin line
    sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' $SSH_CONFIG
    # Restart SSH service to apply changes
    sudo systemctl restart sshd
    echo "Root SSH login disabled."

else
    # Display usage information if an incorrect argument is provided
    echo "Usage: $0 [on|off]"
fi
