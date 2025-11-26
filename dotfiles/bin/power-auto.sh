#!/bin/bash

USER="peaches"
export XDG_RUNTIME_DIR="/run/user/$(id -u $USER)"

# detect power source
if [ -f /sys/class/power_supply/ACAD/online ]; then
    status=$(cat /sys/class/power_supply/ACAD/online)
else
    status=0
fi

if [ "$status" -eq 1 ]; then
    powerprofilesctl set performance
    sudo -u $USER DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus \
        notify-send "⚡ Power Mode" "Switched to Performance (AC plugged in)"
else
    powerprofilesctl set power-saver
    sudo -u $USER DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus \
        notify-send "🔋 Power Mode" "Switched to Power Saver (on Battery)"
fi

