#!/bin/bash

set -e  # Exit immediately if any command fails


echo "==========================================="
echo "Step 1: Installing System Prerequisites"
echo "==========================================="


# Load configuration
source ./config.env

# Update package list
echo "[INFO] Updating package repositories..."
sudo apt-get update -qq

# Install basic dependencies
echo "[INFO] Installing required packages..."
sudo apt-get install -y -qq \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    jq \
    git \
    ca-certificates

# Install AWS CLI prerequisites
echo "[INFO] Installing AWS CLI dependencies..."
sudo apt-get install -y -qq \
    groff \
    less

echo " SUCCESS! Prerequisite installation complete."
echo ""
