#!/bin/bash

# Script to enable or disable root user SSH login on Ubuntu systems.
# Usage: ./set_root_login.sh on  -- to enable root SSH login
#        ./set_root_login.sh off -- to disable root SSH login

if [ "$1" == "on" ]; then
    # Enabling root SSH login
    echo "Enabling root SSH login..."
    # Change PermitRootLogin to yes, allowing root logins
    sudo sed -i '/^#PermitRootLogin/c\PermitRootLogin yes' /etc/ssh/sshd_config
    # Restart SSH service to apply changes
    sudo systemctl restart sshd
    echo "Root SSH login enabled."
elif [ "$1" == "off" ]; then
    # Disabling root SSH login
    echo "Disabling root SSH login..."
    # Change PermitRootLogin to no, preventing root logins
    sudo sed -i '/^PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config
    # Restart SSH service to apply changes
    sudo systemctl restart sshd
    echo "Root SSH login disabled."
else
    # Display usage information if an incorrect argument is provided
    echo "Usage: $0 [on|off]"
fi
