#!/bin/bash

# Get current profile
current=$(powerprofilesctl get)

# Decide next mode + label
case "$current" in
  power-saver)
    next="balanced"
    icon="🌗"
    label="Balanced Mode"
    ;;
  balanced)
    next="performance"
    icon="⚡"
    label="Performance Mode"
    ;;
  performance)
    next="power-saver"
    icon="🔋"
    label="Power Saver Mode"
    ;;
  *)
    next="balanced"
    icon="🌗"
    label="Balanced Mode"
    ;;
esac

# Apply the new profile
powerprofilesctl set "$next"

# Send a notification (works with mako or swaync)
notify-send "Power Profile" "${icon} ${label}"

