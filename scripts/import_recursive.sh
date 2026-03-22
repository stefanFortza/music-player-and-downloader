#!/bin/bash

# Detectează automat rădăcina repository-ului
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$REPO_DIR/media/Arhiva_Personala"

# Verifică dacă s-a furnizat un argument
if [ -z "$1" ]; then
    echo "[EROARE] Te rog să furnizezi calea către folder: import-folder <cale>"
    exit 1
fi

SOURCE_DIR="$1"

# Verifică dacă folderul sursă există
if [ ! -d "$SOURCE_DIR" ]; then
    echo "[EROARE] Folderul '$SOURCE_DIR' nu există."
    exit 1
fi

echo "[...] Se scanează recursiv în $SOURCE_DIR după fișiere audio..."

# Extensii suportate
EXTENSIONS='mp3|flac|wav|m4a|ogg'
COUNT=0

# Folosim find pentru a găsi fișierele (case-insensitive) și le copiem
# Folosim -print0 pentru a gestiona corect numele de fișiere cu spații
find "$SOURCE_DIR" -type f -regextype posix-extended -iregex ".*\.($EXTENSIONS)$" -print0 | while IFS= read -r -d '' file; do
    # Obținem doar numele fișierului pentru a evita structuri de directoare imbricate în target
    FILENAME=$(basename "$file")
    
    # Verificăm dacă fișierul există deja pentru a nu-l suprascrie inutil
    if [ ! -f "$TARGET_DIR/$FILENAME" ]; then
        cp "$file" "$TARGET_DIR/"
        echo "[IMPORT] $FILENAME"
        ((COUNT++))
    else
        echo "[SKIP] $FILENAME (deja existent)"
    fi
done

echo "--------------------------------------------------------"
echo "[SUCCES] Import finalizat! $COUNT fișiere adăugate în Arhiva_Personala."
echo "--------------------------------------------------------"
