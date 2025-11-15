#!/bin/bash
MAXVOL=80  # maximum allowed volume percentage

while true; do
  VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}' | cut -d. -f1)
  if [ "$VOL" -gt "$MAXVOL" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${MAXVOL}%"
  fi
  sleep 1
done
