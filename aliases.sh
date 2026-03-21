# ==========================================
# GitHub Music Player Service
# ==========================================

# Redare din repository
alias play-music="mpv --no-video --shuffle --loop-playlist=inf --input-ipc-server=/tmp/mpv-socket /home/stefantacu/github/music-player-service/media/ > /dev/null 2>&1 &"

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
    echo "$1" >> "/home/stefantacu/github/music-player-service/links.txt"
    echo "[SUCCES] URL injectat. Va fi descărcat automat la următoarea rulare."
}
