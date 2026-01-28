#!/bin/bash

set -e   # Exit immediately if any command fails

echo "==========================================="
echo "Step 2: AWS CLI Setup and Configuration"
echo "==========================================="

source ./config.env

# Install AWS CLI v2
echo "[INFO] Downloading AWS CLI v2..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
echo "[INFO] Installing AWS CLI..."
sudo ./aws/install --update
rm -rf awscliv2.zip aws/


# Verify installation
echo "[INFO] Verifying AWS CLI installation..."
aws --version

echo ""
echo "==========================================="
echo "MANUAL STEP REQUIRED: AWS Configuration"
echo "==========================================="
echo "Please configure AWS credentials with:"
echo "  aws configure"
echo ""
echo "After configuring, verify with:"
echo "  aws sts get-caller-identity"
echo ""
echo "Then continue to the next script."
echo ""
