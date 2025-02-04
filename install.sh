#!/bin/bash
# install.sh


# Allgemeine Einstellungen laden
source config.sh
source functions.sh

# Installationslog
LOG_FILE="logs/install.log"
mkdir -p logs && touch "$LOG_FILE"



# Installationsfunktionen aufrufen






echo "🚀 Starte Server-Installation..."
bash scripts/setup_nginx.sh | tee -a "$LOG_FILE"
bash scripts/setup_php.sh | tee -a "$LOG_FILE"
bash scripts/setup_database.sh | tee -a "$LOG_FILE"
bash scripts/setup_firewall.sh | tee -a "$LOG_FILE"


$u
$g
$dg

install_packages;
docker_and_portainer_install;



eco "✅ Server-Installation abgeschlossen!"

