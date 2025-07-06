#!/bin/bash

set -e

CYAN="\033[0;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${CYAN}[*] Installing Mapsim Assistance ...${NC}"

# 1. Check root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERROR] This script must be run as root${NC}"
   exit 1
fi

# 2. Install dependencies
echo -e "${CYAN}[*] Installing required packages...${NC}"
apt-get update -y

# 3. Download latest mapsim-tunnel.sh from GitHub
INSTALL_DIR="/opt/mapsim/Assistance"
mkdir -p "$INSTALL_DIR"

echo -e "${CYAN}[*] Downloading Mapsim-Assistance.sh...${NC}"
curl -fsSL https://raw.githubusercontent.com/MAPSIM-co/Mapsim_Assistance/main/Mapsim_Assistance.sh -o "$INSTALL_DIR/Mapsim_Assistance.sh"
chmod +x "$INSTALL_DIR/Mapsim_Assistance.sh"

# 4. Add global command
ln -sf "$INSTALL_DIR/Mapsim_Assistance.sh" /usr/local/bin/mapsim_assistance

# 5. Create systemd service
SERVICE_FILE="/etc/systemd/system/Mapsim_Assistance.service"
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Mapsim Assistance
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/Mapsim_Assistance.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 6. Enable and start the service
systemctl daemon-reload
systemctl enable Mapsim_Assistance
systemctl start Mapsim_Assistance

# 7. Done
echo -e "${GREEN}[✓] Mapsim Assistance installed successfully!${NC}"
echo -e "${GREEN}[→] You can now run it manually with: mapsim_assistance${NC}"
