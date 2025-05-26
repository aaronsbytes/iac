#!/bin/bash

# Browser bin path argument
BROWSER_BIN="$1"

# Move to special workspace
hyprctl dispatch togglespecialworkspace incognito

# Launch new private window
"$BROWSER_BIN" -private-window &
