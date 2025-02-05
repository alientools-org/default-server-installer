#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"

eco r "Installing PHP!!!... .. "
log "Installing PHP!!!... .. "

    local dir="../packages"  # Ordner mit den Paketlisten
    local file="$1"
    eco "Installing packages from packages folder!... .. ."
    log "📦 Installing packages from packages folder!... .. ."
    if [[ ! -d "$dir" ]]; then
        eco "❌ Der Ordner '$dir' existiert nicht!"
        log "❌ Der Ordner '$dir' existiert nicht!"
        return 1
    fi
    
    # Durch alle Dateien im Ordner iterieren
    for file in "$dir"/*; do
        if [[ ! -f "$file" ]]; then
            eco "Paketliste $file nicht gefunden!"
            log "❌ Paketliste '$file' nicht gefunden!"
            continue
        fi
        [[ -f "$file" ]] || continue  # Nur Dateien verarbeiten
        eco "📄 Lese Datei: $file"
        log "📄 Lese Datei: $file"


        # Zeile für Zeile Pakete installieren
        while IFS= read -r package; do
            [[ -z "$package" || "$package" == \#* ]] && continue  # Leere Zeilen & Kommentare überspringen
            eco "📦 Installiere: $package"
            log "📦 Installiere: $package"
            sudo apt-get install -y "$package"
        done < "$file"
    done
} 

install_packages "cli"