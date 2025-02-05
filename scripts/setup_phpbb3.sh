#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../functions.sh"

eco "🌍 Installiere phpBB3..."
log "🌍 Installiere phpBB3..."

mkdir -p /var/www/board
cd /var/www/board

read -p "Enter Domain Name:~$ " domain

apache2_config() {
    eco "🔧 Konfiguriere Apache2..."
    log "🔧 Konfiguriere Apache2..."
    cat << EOF > /etc/apache2/sites-available/board.conf
    <VirtualHost *:80>
    ServerName board.blackzspace.de
    DocumentRoot /var/www/board

    <Directory /var/www/board>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/phpbb_error.log
    CustomLog ${APACHE_LOG_DIR}/phpbb_access.log combined
    RewriteEngine on    
    RewriteCond %{SERVER_NAME} =board.blackzspace.de
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
    </VirtualHost>
EOF
}

nginx_config() {
    eco "🔧 Konfiguriere Nginx..."
    log "🔧 Konfiguriere Nginx..."
    cat << EOF > /etc/nginx/sites-available/$domain
    upstream php-handler {
    server unix:/var/run/php/php8.2-fpm.sock;
    }

    server {
        server_name $domain
        listen 80;
        listen [::]:80;
        root /var/www/board;

        index index.php index.html index.htm;

        location / {
            index index.php index.html index.htm;
            try_files $uri $uri/ @rewriteapp;
        }

        location ~ \.php(/|$) {
            include fastcgi_params;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            try_files $uri $uri/ /app.php$is_args$args;
            fastcgi_pass php-handler;
        }

        location @rewriteapp {
            rewrite ^(.*)$ /app.php/$1 last;
        }

        location /install/ {
            try_files $uri $uri/ @rewrite_installapp;
        }

        location ~ \.php(/|$) {
            include fastcgi_params;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            try_files $uri $uri/ /install/app.php$is_args$args;
            fastcgi_pass php-handler;
        }

        location @rewrite_installapp {
            rewrite ^(.*)$ /install/app.php/$1 last;
        }

        location ~ /(config\.php|common\.php|includes|cache|files|store|images/avatars/upload) {
            deny all;
            internal;
        }
    }   
EOF
}

download() {
    eco "Downloading phpBB3!!!... .. ."
    
    eco "Avaliable Languages: 1: German | 2: English."
    log "Available Languages: 1: German | 2: English"


    read -p "Enter Language:~$ " lang

    case $lang in 
        1) wget https://downloads.phpbb.de/pakete/deutsch/3.3/3.3.14/phpBB-3.3.14-deutsch.zip; continue;;
        2) wget https://download.phpbb.com/pub/release/3.3/3.3.14/phpBB-3.3.14.zip; continue;;
        *) eco "Invalid Input!\n Select 1: German or 2: English!"; continue;;
    esac

}


download_apache_file() {
    eco "Apache2 ist installiert."
    log "Apache2 ist installiert."
    download;
    apache2_config;
}

download_nginx_file() {
    eco "Nginx ist installiert."
    log "Nginx ist installiert."
    download;
    nginx_config;
}


check() {
    if dpkg -l | grep -q apache2; then
      download_apache_file
    elif dpkg -l | grep -q nginx; then
        download_nginx_file
    else
        eco "Weder Apache2 noch Nginx sind installiert!"
        log "Weder Apache2 noch Nginx sind installiert!"
    fi
}


extract() {
    unzip *.zip
    sudo chmod 777 -R ./*
    rm -rf *.zip
}



initialize() {
    check;
}

initialize