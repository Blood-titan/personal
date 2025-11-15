#!/usr/bin/env bash
# Rofi USB Power-Off Script
# Lists connected USB drives and powers off the selected one

# List removable devices
devices=$(lsblk -o NAME,RM,SIZE,MODEL,TRAN | awk '$2=="1" {printf "/dev/%s (%s) %s\n",$1,$3,$4}')

# If no USB devices found
if [ -z "$devices" ]; then
    rofi -e "No removable USB drives detected."
    exit 1
fi

# Show menu in rofi
chosen=$(echo "$devices" | rofi -dmenu -i -p "🔌 Power off USB:")

# Exit if nothing chosen
[ -z "$chosen" ] && exit 0

# Extract device name (e.g., /dev/sdb)
device=$(echo "$chosen" | awk '{print $1}')

# Ask confirmation
confirm=$(echo -e "No\nYes" | rofi -dmenu -i -p "Are you sure to power off $device?")

[ "$confirm" != "Yes" ] && exit 0

# Power off the device
udisksctl power-off -b "$device" && \
    rofi -e "✅ $device powered off successfully." || \
    rofi -e "⚠️ Failed to power off $device."
