#!/bin/bash
set -e

echo "🐳 Docker + Kind + Kubectl Installer"

# Docker
if ! command -v docker &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "✅ Docker installed (logout/login needed)"
else
    echo "✅ Docker OK"
fi

# Kind
KIND_VERSION=$(curl -s https://github.com/kubernetes-sigs/kind/releases | grep -oP 'v\d+\.\d+\.\d+' | head -1)
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
sudo install -m 0755 ./kind /usr/local/bin/kind && rm ./kind

# Kubectl  
KUBECTL_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl*

echo "✅ Docker+Kind+Kubectl ready!"
docker --version && kind version && kubectl version --client

