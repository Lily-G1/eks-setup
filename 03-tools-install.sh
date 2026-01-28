#!/bin/bash

set -e

echo "==========================================="
echo "Step 3: Installing DevOps Tools"
echo "==========================================="

source ./config.env

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Terraform Installation
if ! command_exists terraform; then
    echo "[INFO] Installing Terraform..."
    
    # Download and verify HashiCorp GPG key
    wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    
    # Add HashiCorp repository
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    # Install Terraform
    sudo apt-get update -qq
    sudo apt-get install -y -qq terraform
    
    echo "[INFO] Terraform installed successfully"
else
    echo "[INFO] Terraform is already installed"
fi
terraform version


# Install kubectl
if ! command_exists kubectl; then
    echo "[INFO] Installing kubectl..."
    
    # Download latest stable release
    KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    
    # Make executable and move to PATH
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    
    echo "[INFO] kubectl installed successfully"
else
    echo "[INFO] kubectl is already installed"
fi
kubectl version --client --short


# Install eksctl
if ! command_exists eksctl; then
    echo "[INFO] Installing eksctl..."
    
    # Download and extract eksctl
    curl -sLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"
    tar -xzf eksctl_$(uname -s)_amd64.tar.gz
    sudo mv eksctl /usr/local/bin
    rm eksctl_$(uname -s)_amd64.tar.gz
    
    echo "[INFO] eksctl installed successfully"
else
    echo "[INFO] eksctl is already installed"
fi
eksctl version

echo "SUCCESS! Tools installation complete."
echo ""
