#!/bin/bash
# Script de extragere audio batch - Rulat via Systemd

# Detectează automat rădăcina repository-ului indiferent de unde este rulat
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MUSIC_DIR="$REPO_DIR/media/YouTube_Sync"
BATCH_FILE="$REPO_DIR/links.txt"
ARCHIVE_FILE="$REPO_DIR/downloaded.txt"

# Asigură-te că directoarele există
mkdir -p "$MUSIC_DIR"

# Oprește execuția dacă fișierul de link-uri este gol sau nu există
if [ ! -s "$BATCH_FILE" ]; then
    exit 0
fi

# Caută yt-dlp în PATH sau locații comune
YT_DLP=$(which yt-dlp || echo "/usr/local/bin/yt-dlp")

$YT_DLP \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --download-archive "$ARCHIVE_FILE" \
    --batch-file "$BATCH_FILE" \
    --output "$MUSIC_DIR/%(title)s.%(ext)s" \
    --ignore-errors \
    --quiet
