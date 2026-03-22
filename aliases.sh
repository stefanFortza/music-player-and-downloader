# ==========================================
# GitHub Music Player Service (MANUAL)
# ==========================================

# Detectare Automată Cale
if [ -z "$MUSIC_SERVICE_DIR" ]; then
    export MUSIC_SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Redare din repository
# Generăm un playlist temporar cu toate fișierele audio găsite recursiv în media/
# Apoi pornim mpv folosind acel playlist pentru a asigura continuitatea redării.
alias play-music="find \"$MUSIC_SERVICE_DIR/media/\" -type f -regextype posix-extended -iregex '.*\\.(mp3|flac|wav|m4a|ogg)$' > /tmp/mpv-playlist && mpv --no-video --shuffle --loop-playlist=inf --input-ipc-server=/tmp/mpv-socket --playlist=/tmp/mpv-playlist > /dev/null 2>&1 &"

# Control Player
alias stop-music="pkill mpv && rm -f /tmp/mpv-socket /tmp/mpv-playlist"
alias pause-music="echo 'cycle pause' | socat - /tmp/mpv-socket"
alias next-track="echo 'playlist-next' | socat - /tmp/mpv-socket"
alias prev-track="echo 'playlist-prev' | socat - /tmp/mpv-socket"

# Info Melodie Curentă
current-song() {
    if [ ! -S /tmp/mpv-socket ]; then
        echo -e "\033[91m[EROARE]\033[0m Player-ul nu este pornit."
        return 1
    fi
    local TITLE=$(echo '{ "command": ["get_property", "media-title"] }' | socat - /tmp/mpv-socket 2>/dev/null | grep -oP '(?<="data":")[^"]*')
    if [ -z "$TITLE" ]; then
        echo -e "\033[93m[INFO]\033[0m Se încarcă melodia..."
    else
        echo -e "\033[96m[ACUM RULEAZĂ]\033[0m $TITLE"
    fi
}

# Sincronizare Manuală cu Progress Bar (Python)
alias sync-music="\"$MUSIC_SERVICE_DIR/scripts/sync_manager.py\""

# Adăugare URL YouTube
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
    echo -e "\033[92m[SUCCES]\033[0m URL adăugat."

    if [ "$AUTO_SYNC" = true ]; then
        sync-music
    fi
}

# Import fișier local singular
import-song() {
    if [ -z "$1" ]; then
        echo -e "\033[91m[EROARE]\033[0m Sintaxă: import-song <cale>"
        return 1
    fi
    if [ -f "$1" ]; then
        cp "$1" "$MUSIC_SERVICE_DIR/media/Arhiva_Personala/"
        echo -e "\033[92m[SUCCES]\033[0m Melodie importată."
    fi
}

# Import recursiv din folder
alias import-folder="\"$MUSIC_SERVICE_DIR/scripts/import_recursive.sh\""
