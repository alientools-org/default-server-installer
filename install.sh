#!/bin/bash
# install.sh


if [[ $EUID -ne 0 ]]; then
    eco "Dieses Skript muss mit root-Rechten ausgeführt werden!" 
    exit 1
fi


# Allgemeine Einstellungen laden
source config.sh
source functions.sh

# Installationslog
LOG_FILE="logs/install.log"
mkdir -p logs && touch "$LOG_FILE"



# Installationsfunktionen aufrufen





eco r "🚀 Starte Server-Installation..."
bash scripts/setup_nginx.sh | tee -a "$LOG_FILE"
bash scripts/setup_php.sh | tee -a "$LOG_FILE"
bash scripts/setup_database.sh | tee -a "$LOG_FILE"
bash scripts/setup_firewall.sh | tee -a "$LOG_FILE"
bash scripts/setup_docker.sh.sh | tee -a "$LOG_FILE"
bash scripts/setup_unrealircd.sh | tee -a "$LOG_FILE"


$u
$g
$dg

install_packages;




eco r "✅ Server-Installation abgeschlossen!"

