#!/bin/bash

# Ask user for the secret token
read -p "Enter your FRP token: " TOKEN

# Step 1: Update & install unzip
echo "Updating system and installing unzip..."
sudo apt update && sudo apt install unzip -y

# Step 2: Download the zip
echo "Downloading FRP server files..."
curl -o /root/ServerIP.zip https://files.catbox.moe/xdtwva.zip

# Step 3: Unzip the file
echo "Unzipping to /root/ServerIP..."
unzip -o /root/ServerIP.zip -d /root/

# Step 4: Create frps.ini
echo "Creating /root/ServerIP/frps.ini..."
cat <<EOF > /root/ServerIP/frps.ini
[common]
bind_port = 7000
token = $TOKEN
EOF

# Step 5-6: Create systemd service file
echo "Creating systemd service /etc/systemd/system/serverip.service..."
cat <<EOF | sudo tee /etc/systemd/system/serverip.service > /dev/null
[Unit]
Description=Server IP
After=network.target

[Service]
ExecStart=/root/ServerIP/frps -c /root/ServerIP/frps.ini
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Step 7-10: Reload systemd, enable and start service
echo "Enabling and starting FRP service..."
sudo systemctl daemon-reexec
sudo systemctl enable serverip
sudo systemctl start serverip

echo "✅ FRP Server setup complete and running!"
