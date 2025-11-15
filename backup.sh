#!/usr/bin/env bash

# === SETTINGS ===
REPO_URL="https://github.com/Blood-titan/personal.git"
REPO_DIR="$HOME/personal"             # contains .git repo
DOT_DIR="$REPO_DIR/dotfiles"          # actual dotfiles
BUILD_DIR="/tmp/dotfiles-build"       # safe temp build
LOG_FILE="$REPO_DIR/logs/backup.log"
CONFIG_SRC="$HOME/.config"
LOCAL_SRC="$HOME/.local/bin"

mkdir -p "$REPO_DIR/logs"
mkdir -p "$DOT_DIR"

# === RESET BUILD DIR ===
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# === COPY FILES ===
cp -r "$CONFIG_SRC" "$BUILD_DIR/config"
cp -r "$LOCAL_SRC" "$BUILD_DIR/bin"

# === CLEAN HEAVY/UNWANTED FILES ===
rm -rf "$BUILD_DIR/config/discord"
rm -rf "$BUILD_DIR/config/nvim/mason"
rm -rf "$BUILD_DIR/config/nvim/lazy"*/mason
rm -rf "$BUILD_DIR/config/nvim/site"

# Remove embedded .git folders
find "$BUILD_DIR" -type d -name ".git" -exec rm -rf {} +

# Remove large files > 10M
find "$BUILD_DIR" -type f -size +10M -delete

# === CLONE IF NEEDED ===
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone "$REPO_URL" "$REPO_DIR"
fi

# === SYNC BUILD → DOTFILES REPO ===
rm -rf "$DOT_DIR/config" "$DOT_DIR/bin"
cp -r "$BUILD_DIR/config" "$DOT_DIR/config"
cp -r "$BUILD_DIR/bin" "$DOT_DIR/bin"

# === COMMIT & PUSH ===
cd "$REPO_DIR"
git add -A
if git commit -m "Backup $(date '+%Y-%m-%d %H:%M:%S')" ; then
    git push --force origin main
    notify-send "Dotfile Backup" "Backup completed successfully ✔"
    echo "$(date): SUCCESS" >> "$LOG_FILE"
else
    notify-send "Dotfile Backup" "No changes to back up."
    echo "$(date): No changes" >> "$LOG_FILE"
fi

