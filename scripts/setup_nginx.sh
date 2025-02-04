#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"

eco "🌍 Installiere Nginx..."
log "🌍 Installiere Nginx..."


eco "🔧 Konfiguriere Nginx..."
log "🔧 Konfiguriere Nginx..."
sudo systemctl enable nginx
sudo systemctl restart nginx



eco "✅ Nginx erfolgreich installiert!"
log "✅ Nginx erfolgreich installiert!"
