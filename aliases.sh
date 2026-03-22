# ==========================================
# GitHub Music Player Service (MANUAL)
# ==========================================

# Detectare Automată Cale
if [ -z "$MUSIC_SERVICE_DIR" ]; then
    export MUSIC_SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Redare din repository
alias play-music="mpv --no-video --shuffle --loop-playlist=inf --input-ipc-server=/tmp/mpv-socket \"$MUSIC_SERVICE_DIR/media/\" > /dev/null 2>&1 &"

# Control Player
alias stop-music="pkill mpv && rm -f /tmp/mpv-socket"
alias pause-music="echo 'cycle pause' | socat - /tmp/mpv-socket"
alias next-track="echo 'playlist-next' | socat - /tmp/mpv-socket"
alias prev-track="echo 'playlist-prev' | socat - /tmp/mpv-socket"

# Sincronizare Manuală cu Progress Bar (Python)
alias sync-music="\"$MUSIC_SERVICE_DIR/scripts/sync_manager.py\""

# Adăugare URL YouTube
# Utilizare: add-song <URL> [--sync]
add-song() {
    local URL=""
    local AUTO_SYNC=false

    for arg in "$@"; do
        if [[ "$arg" == "--sync" ]]; then
            AUTO_SYNC=true
        else
            URL="$arg"
        fi
    done

    if [ -z "$URL" ]; then
        echo -e "\033[91m[EROARE]\033[0m Sintaxă: add-song <URL> [--sync]"
        return 1
    fi

    echo "$URL" >> "$MUSIC_SERVICE_DIR/links.txt"
    echo -e "\033[92m[SUCCES]\033[0m URL adăugat în links.txt."

    if [ "$AUTO_SYNC" = true ]; then
        sync-music
    else
        echo "Rulează 'sync-music' când vrei să descarci melodiile noi."
    fi
}

# Import fișier local singular
import-song() {
    if [ -z "$1" ]; then
        echo -e "\033[91m[EROARE]\033[0m Sintaxă: import-song <cale_catre_fisier>"
        return 1
    fi
    if [ -f "$1" ]; then
        cp "$1" "$MUSIC_SERVICE_DIR/media/Arhiva_Personala/"
        echo -e "\033[92m[SUCCES]\033[0m Melodia a fost copiată local."
    else
        echo -e "\033[91m[EROARE]\033[0m Fișierul nu există."
    fi
}

# Import recursiv din folder
alias import-folder="\"$MUSIC_SERVICE_DIR/scripts/import_recursive.sh\""
