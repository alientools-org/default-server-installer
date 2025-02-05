#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"


eco "🌍 Installiere Apache..."
log "🌍 Installiere Apache..."


eco "🔧 Konfiguriere Apache..."
log "🔧 Konfiguriere Apache..."

install_package "apache2"



sudo systemctl enable nginx
sudo systemctl restart nginx



eco "✅ Nginx erfolgreich installiert!"
log "✅ Nginx erfolgreich installiert!"