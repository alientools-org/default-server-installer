#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"


log "🌍 Installiere Nginx..."



log "🔧 Konfiguriere Nginx..."
sudo systemctl enable nginx
sudo systemctl restart nginx




log "✅ Nginx erfolgreich installiert!"
