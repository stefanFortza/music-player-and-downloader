#!/bin/bash

# Detectează automat locația de unde se rulează scriptul de instalare
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detectare shell configuration file
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

echo "[1/3] Creare structură directoare în $REPO_DIR..."
mkdir -p "$REPO_DIR"/media/{YouTube_Sync,Arhiva_Personala}
touch "$REPO_DIR"/{links.txt,downloaded.txt}

echo "[2/3] Configurare $SHELL_RC..."
# Exportăm variabila globală pentru proiect
if ! grep -q "export MUSIC_SERVICE_DIR=\"$REPO_DIR\"" "$SHELL_RC"; then
    echo -e "\n# Music Player Service (MANUAL)" >> "$SHELL_RC"
    echo "export MUSIC_SERVICE_DIR=\"$REPO_DIR\"" >> "$SHELL_RC"
fi

# Sursă pentru alias-uri
if ! grep -q "source \$MUSIC_SERVICE_DIR/aliases.sh" "$SHELL_RC"; then
    echo "source \$MUSIC_SERVICE_DIR/aliases.sh" >> "$SHELL_RC"
fi

echo "[3/3] Curățare eventuale urme Systemd vechi..."
systemctl --user stop ytsync.timer ytsync.service 2>/dev/null
systemctl --user disable ytsync.timer ytsync.service 2>/dev/null
rm -f "$HOME/.config/systemd/user/ytsync.service"
rm -f "$HOME/.config/systemd/user/ytsync.timer"

echo "--------------------------------------------------------"
echo "Instalare MANUALĂ finalizată în: $REPO_DIR"
echo "Executați: 'source $SHELL_RC' pentru a activa comenzile."
echo ""
echo "COMENZI DISPONIBILE:"
echo "  add-song <URL>          -> Adaugă în listă fără descărcare"
echo "  add-song <URL> --sync   -> Adaugă și pornește descărcarea imediat"
echo "  sync-music              -> Pornește sincronizarea manuală (Progress Bar fixat)"
echo "  play-music              -> Pornește player-ul"
echo "  stop-music              -> Oprește player-ul"
echo "--------------------------------------------------------"
