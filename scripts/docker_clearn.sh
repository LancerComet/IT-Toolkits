#!/bin/bash

# This script checks if the disk usage is above a certain threshold (default is 10% free space).
# If the available space is less than the threshold, it runs `docker system prune` to clean up
# unused Docker objects such as stopped containers, networks, and dangling images.

# You can use this script as a cron job to periodically clean up Docker cache when necessary.
# For example, to run this script every day at 2:00 AM, add the following line to your crontab:
# 0 2 * * * /path/to/docker_clean.sh

# Set the disk usage threshold percentage (default is 10% free space)
THRESHOLD=10

# Get the disk usage percentage for the root directory (/)
USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')

# If the disk usage is greater than or equal to the threshold, run `docker system prune`
if [ "$USAGE" -ge $((100 - THRESHOLD)) ]; then
    echo "Disk usage is above $THRESHOLD%. Running 'docker system prune'..."
    docker system prune -f
else
    echo "Disk usage is below $THRESHOLD%. No action needed."
fi
