#!/usr/bin/env bash

REPO_URL="https://github.com/Blood-titan/personal.git"
REPO_DIR="$HOME/personal"
DOT_DIR="$REPO_DIR/dotfiles"
BACKUP_TS="$HOME/dotfile-restore-backup-$(date '+%Y%m%d-%H%M%S')"

echo "[+] Starting Dotfile Restore"

# === 1. Clone repo if missing ===
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "[+] Local repo missing → cloning fresh copy"
    rm -rf "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
fi

# === 2. Fetch latest version ===
cd "$REPO_DIR"
git pull --force

# === 3. Backup existing config before restore ===
echo "[+] Backing up current configs → $BACKUP_TS"

mkdir -p "$BACKUP_TS"

if [ -d "$HOME/.config" ]; then
    cp -r "$HOME/.config" "$BACKUP_TS/config"
fi

if [ -d "$HOME/.local/bin" ]; then
    mkdir -p "$BACKUP_TS/local"
    cp -r "$HOME/.local/bin" "$BACKUP_TS/local/bin"
fi

# === 4. Restore .config ===
if [ -d "$DOT_DIR/config" ]; then
    echo "[+] Restoring ~/.config"
    rm -rf "$HOME/.config"
    cp -r "$DOT_DIR/config" "$HOME/.config"
fi

# === 5. Restore ~/.local/bin ===
if [ -d "$DOT_DIR/bin" ]; then
    echo "[+] Restoring ~/.local/bin"
    mkdir -p "$HOME/.local"
    rm -rf "$HOME/.local/bin"
    cp -r "$DOT_DIR/bin" "$HOME/.local/bin"
    chmod -R +x "$HOME/.local/bin" 2>/dev/null
fi

echo "[✔] Restore complete!"
echo "[i] Backup saved at $BACKUP_TS"
notify-send "Dotfile Restore" "Restore completed successfully"

