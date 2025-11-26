#!/bin/bash

# Directory for screenshots
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# File name with timestamp
FILE="$DIR/screenshot-$(date +'%F-%H-%M-%S').png"

# Take screenshot (select region)
if grim -g "$(slurp)" "$FILE"; then
    # Copy to clipboard
    wl-copy < "$FILE"
    # Optional notification
    notify-send "📸 Screenshot saved & copied!" "$FILE"
else
    notify-send "❌ Screenshot canceled"
fi

