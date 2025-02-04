#!/bin/bash


# Allgemeine Einstellungen laden
eco "🚀 Allgemeine Einstellungen laden..."
source config.sh
source functions.sh

eco "Creating installation log..."
# Installationslog
LOG_FILE="logs/install.log"
mkdir -p logs && touch "$LOG_FILE"





eco "🚀 Starte Server-Installation..."
$u
$g
$dg

install_packages;
docker_and_portainer_install

eco "✅ Server-Installation abgeschlossen!"