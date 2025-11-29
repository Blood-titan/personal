#!/usr/bin/env bash

# Simple Wofi submenu for power profiles

current=$(powerprofilesctl get 2>/dev/null)

# Mark current profile
mark() {
  if [ "$1" = "$current" ]; then
    echo "★ $2"
  else
    echo "  $2"
  fi
}

menu="$(cat <<EOF
$(mark performance "Performance")
$(mark balanced "Balanced")
$(mark power-saver "Power Saver")
Cancel
EOF
)"

choice=$(echo "$menu" | wofi --dmenu -p "Power Profile")

case "$choice" in
  *Performance*)
    powerprofilesctl set performance
    notify-send "Power Profile" "⚡ Performance"
    ;;
  *Balanced*)
    powerprofilesctl set balanced
    notify-send "Power Profile" "🌗 Balanced"
    ;;
  *Power\ Saver*)
    powerprofilesctl set power-saver
    notify-send "Power Profile" "🔋 Power Saver"
    ;;
  *Cancel*|*)
    exit 0
    ;;
esac

