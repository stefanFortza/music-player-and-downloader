# 🎵 Music Player Service (Modular & Manual)

Un serviciu de muzică minimalist, controlat din terminal, care sincronizează automat audio de pe YouTube și permite gestionarea unei arhive personale, totul într-un flux de lucru bazat pe Git.

## 🚀 Caracteristici

- **Modularitate:** Se adaptează automat la orice cale de pe sistemul tău.
- **Sincronizare YouTube:** Descarcă doar audio (`mp3`) folosind `yt-dlp`.
- **Interfață Terminal:** Progress bar colorat în Python pentru descărcări.
- **Import Inteligent:** Adăugare de link-uri sau import recursiv de fișiere locale.
- **Control Media:** Folosește `mpv` cu IPC socket pentru control total din terminal (play, stop, pause, skip).
- **Git Friendly:** `.gitignore` configurat pentru a nu urca fișierele audio mari pe GitHub (se păstrează doar link-urile și istoricul).

## 🛠️ Instalare

### 1. Dependențe necesare
Asigură-te că ai instalate următoarele utilitare:
```bash
sudo apt update
sudo apt install mpv yt-dlp socat python3 git
```

### 2. Configurare proiect
Clonează repository-ul și rulează scriptul de instalare:
```bash
cd /cale/catre/music-player-service
chmod +x install.sh
./install.sh
```

### 3. Activare
După instalare, rulează comanda corespunzătoare shell-ului tău (zsh sau bash):
```bash
source ~/.zshrc  # sau source ~/.bashrc
```

## 🎮 Comenzi Disponibile

### Gestionare Muzică
- `add-song <URL>`: Adaugă un link YouTube în coada de descărcare.
- `add-song <URL> --sync`: Adaugă link-ul și pornește imediat descărcarea.
- `sync-music`: Pornește sincronizarea manuală a tuturor link-urilor noi (cu Progress Bar).
- `import-song <cale>`: Copiază un fișier audio local în arhiva personală.
- `import-folder <cale_folder>`: Scanează recursiv un folder și importă toate fișierele audio găsite.

### Control Player
- `play-music`: Pornește redarea în fundal (shuffle & loop).
- `current-song`: Afișează melodia care rulează în acest moment.
- `stop-music`: Oprește redarea și curăță socket-ul.
- `pause-music`: Pune pauză / Reluează redarea.
- `next-track`: Trece la următoarea melodie.
- `prev-track`: Trece la melodia anterioară.

## 📂 Structura Proiectului
- `media/YouTube_Sync/`: Muzica descărcată automat.
- `media/Arhiva_Personala/`: Muzica importată manual.
- `links.txt`: Lista ta de link-uri (urmărită de Git).
- `downloaded.txt`: Istoricul descărcărilor `yt-dlp` pentru a evita duplicatele.
- `aliases.sh`: Inima proiectului, conține toate comenzile de terminal.

---
Creat cu ❤️ pentru terminal.
