#!/bin/bash

REPO_DIR="/home/stefantacu/github/music-player-service"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

echo "[1/4] Se creează directoarele media necesare..."
mkdir -p "$REPO_DIR"/media/{YouTube_Sync,Arhiva_Personala}

echo "[2/4] Se instalează symlink-urile Systemd..."
mkdir -p "$SYSTEMD_USER_DIR"
ln -sf "$REPO_DIR/systemd/ytsync.service" "$SYSTEMD_USER_DIR/ytsync.service"
ln -sf "$REPO_DIR/systemd/ytsync.timer" "$SYSTEMD_USER_DIR/ytsync.timer"

echo "[3/4] Se activează serviciile de fundal..."
systemctl --user daemon-reload
systemctl --user enable --now ytsync.timer

echo "[4/4] Se conectează aliases.sh la ~/.bashrc..."
if ! grep -q "source $REPO_DIR/aliases.sh" ~/.bashrc; then
    echo "source $REPO_DIR/aliases.sh" >> ~/.bashrc
    echo "Alias-urile au fost adăugate în ~/.bashrc"
fi

echo "Instalare completă! Rulați 'source ~/.bashrc' pentru a activa comenzile în terminalul curent."
