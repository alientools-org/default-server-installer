#!/bin/bash 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"


eco "📦 Installiere erforderliche Pakete für Docker..."
log "📦 Installiere erforderliche Pakete für Docker..."

install_package "apt-transport-https ca-certificates curl gnupg2 lsb-release sudo"

eco "🔑 Füge Docker GPG-Schlüssel hinzu..."
log "🔑 Füge Docker GPG-Schlüssel hinzu..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc




# Füge das Docker-Repository hinzu
eco "📝 Füge Docker-Repository hinzu..."
log "📝 Füge Docker-Repository hinzu..."

echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Paketliste aktualisieren
eco "🔄 Aktualisiere Paketlisten..."
log "🔄 Aktualisiere Paketlisten..."

sudo apt-get update -y

# Docker und Docker-Compose installieren
eco "📦 Installiere Docker und Docker-Compose..."
log "📦 Installiere Docker und Docker-Compose..."

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker-Dienst starten und aktivieren
eco "🔄 Starte Docker und aktiviere es beim Booten..."
log "🔄 Starte Docker und aktiviere es beim Booten..."

sudo systemctl start docker
sudo systemctl enable docker

# Prüfe, ob Docker korrekt installiert wurde
eco "🔍 Überprüfe Docker-Installation..."
log "🔍 Überprüfe Docker-Installation..."

sudo docker --version
if [[ $? -ne 0 ]]; then
    eco "❌ Docker-Installation fehlgeschlagen!"
    eco "❌ Docker-Installation fehlgeschlagen!"

    exit 1
else
    eco "✅ Docker wurde erfolgreich installiert!"
    log "✅ Docker wurde erfolgreich installiert!"

fi

# Installiere Portainer-CE
eco "📦 Installiere Portainer-CE..."
log "📦 Installiere Portainer-CE..."

sudo docker volume create portainer_data
sudo docker run -d \
  -p 8000:8000 -p 9000:9000 \
  --name portainer \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce

# Zeige Status von Portainer
eco "🔄 Überprüfe Portainer-Installation..."
log "🔄 Überprüfe Portainer-Installation..."

sudo docker ps | grep portainer
if [[ $? -ne 0 ]]; then
    eco "❌ Portainer-Installation fehlgeschlagen!"
    log "❌ Portainer-Installation fehlgeschlagen!"

    exit 1
else
    eco "✅ Portainer wurde erfolgreich installiert und läuft auf http://<deine-ip>:9000"
    log "✅ Portainer wurde erfolgreich installiert und läuft auf http://<deine-ip>:9000"

fi

# Abschließende Nachricht
eco "✅ Docker und Portainer-CE wurden erfolgreich installiert!"
log "✅ Docker und Portainer-CE wurden erfolgreich installiert!"


eco "Configuring Nginx-Webserver to make Portainer available by Domain!"
log "Configuring Nginx-Webserver to make Portainer available by Domain!"






create_nginx_config() {
    local domain="$1"
    local port="$2"
    local config_path="/etc/nginx/sites-available/$domain"

    # Prüfen, ob Parameter übergeben wurden
    if [[ -z "$domain" || -z "$port" ]]; then
        echo "❌ Fehlende Argumente! Nutzung: create_nginx_config <domain> <port>"
        return 1
    fi

    # Nginx-Konfiguration erstellen
    echo "📄 Erstelle Nginx-Konfiguration für $domain auf Port $port..."
    cat <<EOF | sudo tee "$config_path" > /dev/null
    server {
        listen 80;
        server_name $domain;

        location / {
            proxy_pass http://localhost:$port/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
            proxy_http_version 1.1;
            proxy_buffering off;
            proxy_request_buffering off;
        }
    }
EOF
}



# Create Nginx Config
read -p "Enter Domain-Name:~$ " domain

eco "Configurin Portainer for $domain !!!"
create_nginx_config "$domain" "9000"

# Konfiguration aktivieren
sudo ln -s "$config_path" "/etc/nginx/sites-enabled/"

# Nginx testen & neu starten
echo "🔄 Teste Nginx-Konfiguration..."
sudo nginx -t && sudo systemctl reload nginx

echo "✅ Nginx-Konfiguration für $domain erfolgreich erstellt & aktiviert!"