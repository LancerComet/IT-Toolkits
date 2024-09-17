#!/bin/sh

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <new-hostname>"
  exit 1
fi

# Get the new hostname
new_hostname=$1

# Print the current hostname
current_hostname=$(cat /etc/hostname)
echo "Current hostname: $current_hostname"

# Update /etc/hostname
echo $new_hostname | sudo tee /etc/hostname > /dev/null
echo "Hostname has been changed to: $new_hostname"

# Update /etc/hosts with the new hostname
sudo sed -i "s/127\.0\.1\.1\s*${current_hostname}/127.0.1.1\t${new_hostname}/g" /etc/hosts
echo "/etc/hosts has been updated"

# Inform the user to reboot the system
echo "Please reboot the system to apply the new hostname: sudo reboot"
