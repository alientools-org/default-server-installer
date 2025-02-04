#!/bin/bash


# Allgemeine Einstellungen laden
source config.sh
source functions.sh

# Installationslog
LOG_FILE="logs/install.log"
mkdir -p logs && touch "$LOG_FILE"


install_packages;