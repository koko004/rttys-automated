#!/bin/bash

# Función para instalar docker y docker-compose
install_docker() {
    echo "Checking for Docker installation..."
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing Docker..."
        apt update && apt install -y docker.io
    else
        echo "Docker is already installed."
    fi

    echo "Checking for Docker Compose installation..."
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose not found. Installing Docker Compose..."
        apt install -y docker-compose
    else
        echo "Docker Compose is already installed."
    fi
}

# Función para instalar el servidor rttys
install_rttys_server() {
    install_docker

    echo "Creating rttys directory and configuration file..."
    mkdir -p rttys
    cat > rttys/rttys.yml <<EOF                                                             
services:
    rttys:
        stdin_open: true
        tty: true
        restart: always
        ports:
            - 5912:5912
            - 5913:5913
            - 5914:5914
        image: zhaojh329/rttys:latest
        command: run --addr-http-proxy :5914
        environment:
          - ARGS="-a :5912 -u admin -p password"
EOF

    echo "Starting rttys server with Docker Compose..."
    docker-compose -f rttys/rttys.yml up -d
    echo "rttys server installed and started."
    read -n 1 -s -r -p "Press any key to continue..."
    clear
    echo
}

# Función para instalar el cliente rtty
install_rtty_client() {
    echo "Installing dependencies for rtty client..."
    apt update
    apt install -y libev-dev libssl-dev cmake make build-essential

    echo "Cloning rtty repository..."
    git clone --recursive https://github.com/zhaojh329/rtty.git

    echo "Building and installing rtty client..."
    cd rtty || exit
    mkdir build && cd build
    cmake ..
    make install
    echo "rtty client installed."

    # Solicitar información para crear el servicio
    read -p "Enter your device ID: " device_id
    read -p "Enter the server IP address: " server_ip
    read -p "Enter the device description: " device_description

    # Crear el servicio de systemd para rtty
    echo "Creating systemd service for rtty client..."
    cat > /etc/systemd/system/rtty.service <<EOF
[Unit]
Description=RTTY Client
After=network.target

[Service]
ExecStart=/usr/local/bin/rtty -I '$device_id' -h '$server_ip' -p 5912 -a -v -d '$device_description'
Restart=always
User=$USER

[Install]
WantedBy=multi-user.target
EOF

    # Recargar los servicios de systemd y habilitar el servicio
    systemctl daemon-reload
    systemctl enable rtty.service
    systemctl start rtty.service

    echo "rtty client service installed and started."
    read -n 1 -s -r -p "Press any key to continue..."
    clear
    echo
}

# Función para mostrar el menú
show_menu() {
    clear
    echo -e "\033[1;33m"
    echo "      _   _             "
    echo " _ __| |_| |_ _   _ ___ "
    echo "| '__| __| __| | | / __|"
    echo "| |  | |_| |_| |_| \\__ \\"
    echo "|_|   \__|\__|\__, |___/"
    echo "              |___/     "
    echo -e "\033[0m"
    echo "Select an option:"
    echo "1. Install rttys server"
    echo "2. Install rtty client"
    echo "3. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            install_rttys_server
            ;;
        2)
            install_rtty_client
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Loop para mantener el menú activo
while true; do
    show_menu
done
