#!/usr/bin/env bash

# === CONFIG ===
THEMES_DIR="$HOME/.config/themes"          # << your main themes folder
CURRENT_FILE="$THEMES_DIR/.current"
HYPR_DIR="$HOME/.config/hypr"
HYPR_MAIN="$HYPR_DIR/hyprland.conf"
WAYBAR_DIR="$HOME/.config/waybar"

# === FUNCTIONS ===
reload_hypr() {
    hyprctl reload > /dev/null 2>&1
}

reload_waybar() {
    pkill waybar && sleep 0.5 && waybar > /dev/null 2>&1 &
}

set_wallpaper() {
    local img="$1"
    if [ -f "$img" ]; then
        if command -v swww >/dev/null 2>&1; then
            swww img "$img" --transition-type wipe --transition-fps 60 --transition-duration 0.5
        elif command -v swaybg >/dev/null 2>&1; then
            pkill swaybg
            swaybg -i "$img" -m fill &
        fi
    fi
}

set_gtk_theme() {
    local theme_file="$1"
    if [ -f "$theme_file" ]; then
        gtk_theme=$(cat "$theme_file")
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null
    fi
}

set_qt_theme() {
    local theme_file="$1"
    if [ -f "$theme_file" ]; then
        qt_theme=$(cat "$theme_file")
        sed -i "s|^style=.*|style=$qt_theme|" "$HOME/.config/qt6ct/qt6ct.conf" 2>/dev/null
    fi
}

# === MAIN LOGIC ===
themes=($(ls -1 "$THEMES_DIR" | grep -v '\.current' | sort))
count=${#themes[@]}

if [ $count -eq 0 ]; then
    notify-send "No themes found in $THEMES_DIR" && exit 1
fi

if [ ! -f "$CURRENT_FILE" ]; then
    echo "${themes[0]}" > "$CURRENT_FILE"
fi

current=$(cat "$CURRENT_FILE")

# Find current index
for i in "${!themes[@]}"; do
    if [[ "${themes[$i]}" == "$current" ]]; then
        index=$i
        break
    fi
done

# Choose next theme (wrap around)
next_index=$(( (index + 1) % count ))
next_theme="${themes[$next_index]}"
echo "$next_theme" > "$CURRENT_FILE"

theme_path="$THEMES_DIR/$next_theme"

# === APPLY THEME ===

# Hyprland theme
if [ -f "$theme_path/hypr.conf" ]; then
    ln -sf "$theme_path/hypr.conf" "$HYPR_DIR/theme.conf"
    if ! grep -q "source = $HYPR_DIR/theme.conf" "$HYPR_MAIN"; then
        echo "source = $HYPR_DIR/theme.conf" >> "$HYPR_MAIN"
    fi
fi

# Waybar theme
if [ -f "$theme_path/waybar.css" ]; then
    ln -sf "$theme_path/waybar.css" "$WAYBAR_DIR/style.css"
fi

# Wallpaper
if [ -f "$theme_path/wallpaper.jpg" ]; then
    set_wallpaper "$theme_path/wallpaper.jpg"
elif [ -f "$theme_path/wallpaper.png" ]; then
    set_wallpaper "$theme_path/wallpaper.png"
fi

# GTK / QT
set_gtk_theme "$theme_path/gtk-theme.txt"
set_qt_theme "$theme_path/qt-theme.txt"

# Reload environments
reload_hypr
reload_waybar

notify-send "🎨 Switched to theme: $next_theme" -t 2000

