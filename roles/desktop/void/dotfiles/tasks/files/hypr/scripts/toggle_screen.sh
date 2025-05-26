#!/bin/bash

# Get the current brightness level
current_brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)

# Check if the current brightness is 0
if [ "$current_brightness" -eq 0 ]; then
    # Set brightness to 100%
    brightnessctl s 100%
else
    # Set brightness to 0%
    brightnessctl s 0%
fi
