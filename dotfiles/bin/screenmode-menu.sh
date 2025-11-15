#!/bin/bash
# Hyprland projector mode menu (using rofi)

# --- CONFIG ---
INTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.internal==true) | .name')
EXTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.internal!=true) | .name' | head -n 1)
MENU_APP="rofi"
# ---

if [[ -z "$EXTERNAL" ]]; then
    notify-send "❌ No external display detected"
    exit 1
fi

CHOICE=$(echo -e "🪞 Mirror (Duplicate)\n🧩 Extend (Second Screen)\n📴 Turn Off Projector" | \
    $MENU_APP -dmenu -p "Display Mode:")

case "$CHOICE" in
    *Mirror*)
        hyprctl keyword monitor "$EXTERNAL,preferred,auto,mirror,$INTERNAL"
        notify-send "🪞 Mirroring display to projector"
        ;;
    *Extend*)
        WIDTH=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$INTERNAL\") | .width")
        hyprctl keyword monitor "$EXTERNAL,preferred,${WIDTH}x0,auto"
        notify-send "🧩 Extended desktop to the right"
        ;;
    *Turn*)
        hyprctl keyword monitor "$EXTERNAL,disable"
        notify-send "📴 Projector turned off"
        ;;
    *)
        exit 0
        ;;
esac
