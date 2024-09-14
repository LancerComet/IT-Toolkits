#!/bin/bash

# Print CPU temperature
echo "=== CPU Temperature ==="
if command -v sensors &> /dev/null; then
    sensors | grep 'Core' || echo "Unable to retrieve CPU temperature. Please check if 'sensors' is configured correctly."
else
    echo "'sensors' command not found. Please install 'lm-sensors'."
fi

# Check for NVIDIA GPU and print temperature
echo "=== GPU Temperature ==="
if command -v nvidia-smi &> /dev/null; then
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    if [ -n "$gpu_temp" ]; then
        echo "NVIDIA GPU Temperature: $gpu_temp°C"
    else
        echo "Unable to retrieve GPU temperature."
    fi
else
    echo "NVIDIA GPU not detected or 'nvidia-smi' command not found."
fi

# Print hard drive temperature
echo "=== Hard Drive Temperature ==="
if command -v smartctl &> /dev/null; then
    for device in /dev/sd[a-z]; do
        if [ -e "$device" ]; then
            temperature=$(smartctl -A "$device" | grep -i 'Temperature_Celsius' | awk '{print $10}')
            if [ -z "$temperature" ]; then
                echo "$device: Unable to retrieve temperature or the device doesn't support SMART."
            else
                echo "$device: $temperature°C"
            fi
        fi
    done
else
    echo "'smartctl' command not found. Please install 'smartmontools'."
fi
