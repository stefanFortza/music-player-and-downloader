#!/usr/bin/env python3
import os
import subprocess
import sys
import re
import argparse

# Culori terminal
GREEN = "\033[92m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"

def get_repo_dir():
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def draw_progress_bar(percent, title, info="", length=40):
    filled_length = int(length * percent // 100)
    bar = "█" * filled_length + "-" * (length - filled_length)
    # Curățăm linia și scriem progresul
    sys.stdout.write(f"\r\033[K{CYAN}[SYNC]{RESET} |{GREEN}{bar}{RESET}| {percent:3.1f}% | {info} | {title[:30]}...")
    sys.stdout.flush()

def run_sync():
    repo_dir = get_repo_dir()
    music_dir = os.path.join(repo_dir, "media", "YouTube_Sync")
    batch_file = os.path.join(repo_dir, "links.txt")
    archive_file = os.path.join(repo_dir, "downloaded.txt")
    
    if not os.path.exists(batch_file) or os.stat(batch_file).st_size == 0:
        print(f"{YELLOW}[INFO]{RESET} Nu există link-uri de procesat în links.txt.")
        return

    os.makedirs(music_dir, exist_ok=True)

    cmd = [
        "yt-dlp",
        "--extract-audio",
        "--audio-format", "mp3",
        "--audio-quality", "0",
        "--no-playlist",
        "--playlist-items", "1",
        "--download-archive", archive_file,
        "--batch-file", batch_file,
        "--output", f"{music_dir}/%(title)s.%(ext)s",
        "--ignore-errors",
        "--newline",
        "--progress-template", "download:[download] %(progress._percent_str)s of %(progress._total_bytes_str)s at %(progress._speed_str)s ETA %(progress._eta_str)s"
    ]

    print(f"{CYAN}>>> Inițiere sincronizare manuală...{RESET}")
    
    try:
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)
        
        current_title = "Pregătire..."
        current_info = ""
        
        for line in process.stdout:
            line = line.strip()
            
            # Detectăm destinația pentru a afla titlul
            if "Destination:" in line:
                current_title = os.path.basename(line.split("Destination:")[1].strip())
                print(f"\n{YELLOW}Procesez:{RESET} {current_title}")
            
            # Detectăm dacă este deja descărcată
            elif "has already been recorded in the archive" in line:
                sys.stdout.write(f"\r\033[K{YELLOW}[SKIP]{RESET} Melodie deja existentă în arhivă.\n")
                continue

            # Parsăm progresul (prefixat de noi cu 'download:')
            elif line.startswith("download:[download]"):
                progress_part = line.replace("download:[download]", "").strip()
                # Extragem procentul
                percent_match = re.search(r"(\d+\.\d+)%", progress_part)
                if percent_match:
                    percent = float(percent_match.group(1))
                    # Extragem restul info (speed, ETA)
                    info_match = re.search(r"at (.*)$", progress_part)
                    current_info = info_match.group(1) if info_match else ""
                    draw_progress_bar(percent, current_title, current_info)

        process.wait()
        if process.returncode == 0:
            print(f"\n\n{GREEN}[SUCCES]{RESET} Sincronizare finalizată cu succes!")
        else:
            print(f"\n\n{RED}[EROARE]{RESET} Procesul yt-dlp s-a terminat cu codul {process.returncode}")

    except Exception as e:
        print(f"\n{RED}[EROARE FATALĂ]{RESET} {str(e)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Music Player Sync Manager")
    parser.add_argument("--now", action="store_true", help="Rulează sincronizarea imediat")
    args = parser.parse_args()
    
    try:
        run_sync()
    except KeyboardInterrupt:
        print(f"\n\n{YELLOW}[STOP]{RESET} Sincronizare întreruptă de utilizator.")
        sys.exit(0)
