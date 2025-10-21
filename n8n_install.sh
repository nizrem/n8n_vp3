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

# Download Dockerfile
echo "📥 Downloading Dockerfile..."
curl -fsSL https://raw.githubusercontent.com/zero2launch/n8n_vps/refs/heads/main/Dockerfile -o ~/Dockerfile

# Docker Compose Setup
echo "🐳 Setting up Docker Compose..."
curl -fsSL https://raw.githubusercontent.com/zero2launch/n8n_vps/refs/heads/main/compose.yaml -o ~/compose.yaml
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"

# Build and start containers
echo "🔨 Building custom n8n image with ffmpeg..."
cd ~
sudo -E docker compose build
sudo -E docker compose up -d

echo "🎉 Installation complete! Access your service at: $EXTERNAL_IP"
