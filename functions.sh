#!/bin/bash


export i="eco "Installing package " && sudo apt-get install -y "
export u="eco "Updaing packages-list!" && sudo apt-get update"
export g="eco "Upgrading packages" && sudo apt-get upgrade -y"
export dg="eco "Performing Dist-Upgrade!" && sudo apt-get dist-upgrade -y"

export gc="eco "Cloning repository" && git clone "



log() {
    echo -e "[ $(date +'%Y-%m-%d %H:%M:%S') ] $1"
}



eco() {
    local reset="\e[0m"
    local bold="\e[1m"
    local underline="\e[4m"

    # Farben
    local b="\e[30m"
    local r="\e[31m"
    local g="\e[32m"
    local y="\e[33m"
    local bl="\e[34m"
    local m="\e[35m"
    local c="\e[36m"
    local w="\e[37m"

    # Hintergrundfarben (optional)
    local bg_b="\e[40m"
    local bg_r="\e[41m"
    local bg_g="\e[42m"
    local bg_y="\e[43m"
    local bg_bl="\e[44m"
    local bg_m="\e[45m"
    local bg_c="\e[46m"
    local bg_w="\e[47m"

    # Hilfe anzeigen
    if [[ "$1" == "--help" ]]; then
        echo -e "Usage: eco <farbe> [bold] [underline] \"Text\""
        echo -e "Farben: black, red, green, yellow, blue, magenta, cyan, white"
        echo -e "Optionen: bold (fett), underline (unterstrichen)"
        return
    fi

    local color=""
    local text=""

    # Argumente verarbeiten
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            b|r|g|y|bl|m|c|w)
                color="${!1}"
                ;;
            bo)
                color+="$bold"
                ;;
            u)
                color+="$underline"
                ;;
            *)
                text="$1"
                ;;
        esac
        shift
    done

    # Ausgabe
    echo -e "${color}Console:~$ ${text}${reset}"
}

add_path() {

    eco "Adding smth. to path:~$ "
    eco "Enter path of script or binary you want to add"
    read -p "Console:~$ " add
    export PATH=$add:$PATH 
 
}

apt_install() {
    while true;
    do 
    $u 
    $g 
    $dg 
    eco "APT-Installer started... .. ."
    read -p "APT-Install:~$ " pkg
    $i $pkg
    done
}

install_package() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        log "❌ Paketliste '$file' nicht gefunden!"
        return 1
    fi

    while IFS= read -r package; do
        [[ -z "$package" || "$package" == \#* ]] && continue
        log "📦 Installiere: $package"
        sudo apt-get install -y "$package"
    done < "$file"
}

install_packages() {
    local dir="packages"  # Ordner mit den Paketlisten
    local file="$1"
    eco "Installing packages from packages folder!... .. ."
    if [[ ! -d "$dir" ]]; then
        echo "❌ Der Ordner '$dir' existiert nicht!"
        return 1
    fi
    
    # Durch alle Dateien im Ordner iterieren
    for file in "$dir"/*; do
        if [[ ! -f "$file" ]]; then
            log "❌ Paketliste '$file' nicht gefunden!"
            return 1
        fi
        [[ -f "$file" ]] || continue  # Nur Dateien verarbeiten
        echo "📄 Lese Datei: $file"

        # Zeile für Zeile Pakete installieren
        while IFS= read -r package; do
            [[ -z "$package" || "$package" == \#* ]] && continue  # Leere Zeilen & Kommentare überspringen
            echo "📦 Installiere: $package"
            sudo apt-get install -y "$package"
        done < "$file"
    done
}




docker_and_portainer_install() {
    eco "Installing docker and portainer!!!... .. ."
    # Add Docker's official GPG key:
    sudo apt-get update
    install_package "install ca-certificates curl"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    $u
    install_package "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
}



