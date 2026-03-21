# ==========================================
# GitHub Music Player Service (Modular)
# ==========================================

# Folosește variabila MUSIC_SERVICE_DIR injectată la instalare
if [ -z "$MUSIC_SERVICE_DIR" ]; then
    export MUSIC_SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Redare din repository
alias play-music="mpv --no-video --shuffle --loop-playlist=inf --input-ipc-server=/tmp/mpv-socket \"$MUSIC_SERVICE_DIR/media/\" > /dev/null 2>&1 &"

# Control
alias stop-music="pkill mpv && rm -f /tmp/mpv-socket"
alias pause-music="echo 'cycle pause' | socat - /tmp/mpv-socket"
alias next-track="echo 'playlist-next' | socat - /tmp/mpv-socket"
alias prev-track="echo 'playlist-prev' | socat - /tmp/mpv-socket"

# Funcție de adăugare URL
add-song() {
    if [ -z "$1" ]; then
        echo "[EROARE] Sintaxă: add-song <URL>"
        return 1
    fi
    echo "$1" >> "$MUSIC_SERVICE_DIR/links.txt"
    echo "[SUCCES] URL injectat. Va fi descărcat automat la următoarea rulare."
}
