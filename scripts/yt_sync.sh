#!/bin/bash
# Script de extragere audio batch - Rulat via Systemd

# Căi absolute către repository
REPO_DIR="/home/stefantacu/github/music-player-service"
MUSIC_DIR="$REPO_DIR/media/YouTube_Sync"
BATCH_FILE="$REPO_DIR/links.txt"
ARCHIVE_FILE="$REPO_DIR/downloaded.txt"

# Oprește execuția dacă fișierul de link-uri este gol sau nu există
if [ ! -s "$BATCH_FILE" ]; then
    exit 0
fi

/usr/local/bin/yt-dlp \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --download-archive "$ARCHIVE_FILE" \
    --batch-file "$BATCH_FILE" \
    --output "$MUSIC_DIR/%(title)s.%(ext)s" \
    --ignore-errors \
    --quiet
