#!/bin/bash


# Allgemeine Einstellungen laden
eco "🚀 Allgemeine Einstellungen laden..."
source config.sh
source functions.sh

bash scripts/setup_docker.sh.sh | tee -a "$LOG_FILE"

eco "Creating installation log..."
# Installationslog
LOG_FILE="logs/install.log"
mkdir -p logs && touch "$LOG_FILE"





eco "🚀 Starte Server-Installation..."
$u
$g
$dg

install_packages;
setup_docker;

eco "✅ Server-Installation abgeschlossen!"