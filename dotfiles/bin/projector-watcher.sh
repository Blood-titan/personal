#!/bin/bash
# Auto-detect projector and prompt user to choose Mirror / Extend / Off

# --- CONFIG ---
MENU_APP="wofi"   # can be 'rofi' if preferred
INTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.internal==true) | .name')
# ---

prompt_display_mode() {
    local EXTERNAL="$1"

    CHOICE=$(echo -e "🪞 Mirror (Duplicate for PPT/Canva)\n🧩 Extend (Second Screen)\n📴 Turn Off Projector" \
        | $MENU_APP --dmenu -p "Display Mode:")

    case "$CHOICE" in
        *Mirror*)
            hyprctl keyword monitor "$EXTERNAL,preferred,auto,mirror,$INTERNAL"
            notify-send "🪞 Mirroring display to projector"
            ;;
        *Extend*)
            WIDTH=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$INTERNAL\") | .width")
            hyprctl keyword monitor "$EXTERNAL,preferred,${WIDTH}x0,auto"
            notify-send "🧩 Extended desktop (projector to the right)"
            ;;
        *Turn*)
            hyprctl keyword monitor "$EXTERNAL,disable"
            notify-send "📴 Projector disabled"
            ;;
        *)
            ;;
    esac
}

# --- MAIN LOOP ---
notify-send "🎬 Projector watcher started"

# Continuously monitor for display connection changes
while true; do
    # Wait for display plug/unplug event via DRM subsystem
    inotifywait -e create,delete /sys/class/drm > /dev/null 2>&1

    # Small delay for detection to settle
    sleep 1

    EXTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.internal!=true) | .name' | head -n 1)

    if [[ -n "$EXTERNAL" ]]; then
        # External monitor plugged in
        notify-send "🖥️ Projector detected: $EXTERNAL"
        prompt_display_mode "$EXTERNAL"
    else
        notify-send "🔌 Projector disconnected"
    fi
done
