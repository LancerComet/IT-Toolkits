#!/bin/bash

# This script is used for setting journal log max size.

# Check necessary paramater.
if [ -z "$1" ]; then
    echo "Usage: $0 <max-space>"
    echo "Example: $0 1000M"
    exit 1
fi

# Check root permission.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

MAX_SPACE=$1

# Backup existing journald.conf.
cp /etc/systemd/journald.conf /etc/systemd/journald.conf.bak

# Update SystemMaxUse.
if grep -q "^SystemMaxUse=" /etc/systemd/journald.conf; then
    # Replace if exists
    sed -i "s/^SystemMaxUse=.*/SystemMaxUse=$MAX_SPACE/" /etc/systemd/journald.conf
else
    # Add if doesn't exist
    echo "SystemMaxUse=$MAX_SPACE" >> /etc/systemd/journald.conf
fi

# Restart journald
systemctl restart systemd-journald

echo "Journal log max space set to $MAX_SPACE and systemd-journald restarted."
