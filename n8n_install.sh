#!/bin/bash

# System Update
echo "🔄 Updating Ubuntu system..."
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean
echo "✅ Ubuntu system updated!"

# Docker Installation
echo "🚀 Starting Docker installation..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce
echo "✅ Docker installation completed!"

# Creating n8n Data Volume
echo "📂 Creating n8n data volume..."
cd ~
mkdir -p n8n_data
sudo chown -R 1000:1000 n8n_data
sudo chmod -R 755 n8n_data
echo "✅ n8n data volume is ready!"

# Docker Compose Setup
echo "🐳 Setting up Docker Compose..."
wget https://raw.githubusercontent.com/zero2launch/n8n_vps/refs/heads/main/compose.yaml -O compose.yaml
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
sudo -E docker compose up -d

# Wait for n8n to start
echo "⏳ Waiting for n8n to start..."
sleep 10

# Install ffmpeg in n8n container
echo "🎬 Installing ffmpeg in n8n container..."
sudo docker exec -u root n8n_container sh -c "apk update && apk add ffmpeg"
echo "✅ ffmpeg installed in n8n container!"

echo "🎉 Installation complete! Access your service at: $EXTERNAL_IP"
