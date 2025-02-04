#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"

eco "Installing Docker and Portainer!... .. ."

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
docker --version
docker compose version
docker volume create portainer_data
docker run -d \
  --name=portainer \
  --restart=always \
  -p 8000:8000 -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce



eco "Docker & Portainer Installed!... .. ."

eco "Configuring Nginx-Webserver to make Portainer available by Domain!"



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



read -p "Enter Domain-Name:~$ " domain

eco "Configurin Portainer for $domain !!!"
create_nginx_config "$domain" "9000"

# Konfiguration aktivieren
sudo ln -s "$config_path" "/etc/nginx/sites-enabled/"

# Nginx testen & neu starten
echo "🔄 Teste Nginx-Konfiguration..."
sudo nginx -t && sudo systemctl reload nginx

echo "✅ Nginx-Konfiguration für $domain erfolgreich erstellt & aktiviert!"