#!/bin/bash

# Detectează automat locația de unde se rulează scriptul de instalare
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

echo "[1/4] Creare structură directoare în $REPO_DIR..."
mkdir -p "$REPO_DIR"/media/{YouTube_Sync,Arhiva_Personala}
touch "$REPO_DIR"/{links.txt,downloaded.txt}

echo "[2/4] Generare și instalare Systemd..."
mkdir -p "$SYSTEMD_USER_DIR"
# Generăm fișierul .service din template, înlocuind placeholder-ul cu calea reală
sed "s|REPO_PATH|$REPO_DIR|g" "$REPO_DIR/systemd/ytsync.service.template" > "$SYSTEMD_USER_DIR/ytsync.service"
ln -sf "$REPO_DIR/systemd/ytsync.timer" "$SYSTEMD_USER_DIR/ytsync.timer"

echo "[3/4] Activare servicii de fundal..."
systemctl --user daemon-reload
systemctl --user enable --now ytsync.timer

echo "[4/4] Configurare ~/.bashrc..."
# Exportăm variabila globală pentru proiect
if ! grep -q "export MUSIC_SERVICE_DIR=\"$REPO_DIR\"" ~/.bashrc; then
    echo "export MUSIC_SERVICE_DIR=\"$REPO_DIR\"" >> ~/.bashrc
fi

# Sursă pentru alias-uri
if ! grep -q "source \$MUSIC_SERVICE_DIR/aliases.sh" ~/.bashrc; then
    echo "source \$MUSIC_SERVICE_DIR/aliases.sh" >> ~/.bashrc
    echo "Configurarea a fost adăugată în ~/.bashrc"
fi

echo "--------------------------------------------------------"
echo "Instalare finalizată în: $REPO_DIR"
echo "Executați: 'source ~/.bashrc' pentru a activa comenzile."
echo "Comenzi disponibile: play-music, stop-music, add-song <URL>"
echo "--------------------------------------------------------"
