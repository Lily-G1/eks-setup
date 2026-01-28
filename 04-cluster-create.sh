#!/bin/bash

set -e

echo "==========================================="
echo "Step 4: Creating EKS Cluster"
echo "==========================================="

source ./config.env

echo "[INFO] Using AWS Region: $AWS_REGION"
echo "[INFO] Cluster Name: $CLUSTER_NAME"

# Verify AWS credentials
echo "[INFO] Verifying AWS credentials..."
aws sts get-caller-identity --query Arn --output text

echo ""
echo "Select cluster creation method:"
echo "1) eksctl (Recommended for simplicity)"
echo "2) Terraform (Infrastructure as Code)"
read -p "Enter choice [1-2]: " METHOD

case $METHOD in
    1)
        # Option 1: Create cluster with eksctl
        echo "[INFO] Creating EKS cluster using eksctl..."
        
        eksctl create cluster \
            --name $CLUSTER_NAME \
            --region $AWS_REGION \
            --version $EKS_VERSION \
            --nodegroup-name workers \
            --node-type $NODE_TYPE \
            --nodes $MIN_NODES \
            --nodes-min $MIN_NODES \
            --nodes-max $MAX_NODES \
            --managed \
            --full-ecr-access \
            --alb-ingress-access \
            --asg-access \
            --verbose 4
        
        # Configure kubectl context
        aws eks update-kubeconfig \
            --region $AWS_REGION \
            --name $CLUSTER_NAME
        ;;
    2)
        # Option 2: Create cluster with Terraform
        echo "[INFO] Creating EKS cluster using Terraform..."
        echo "[WARNING] Ensure you have Terraform files in ./eks-terraform directory"
        
        # Initialize and apply Terraform
        cd eks-terraform || { echo "Error: terraform directory not found"; exit 1; }
        terraform init
        terraform plan -out=tfplan
        terraform apply tfplan
        
        #-----------------------------------------1
        # Before line 61, add:
#        echo Creating .kube directory..."
#        mkdir -p ~/.kube
        #-----------------------------------------1
        # Extract kubeconfig from Terraform output
#        terraform output -raw kubeconfig > ~/.kube/config
        
        cd ..
        ;;
    *)
        echo "[ERROR] Invalid selection. Exiting."
        exit 1
        ;;
esac

# Configure kubectl to access the EKS cluster
echo "[INFO] Configuring kubectl to access EKS cluster..."
aws eks update-kubeconfig \
    --region $AWS_REGION \
    --name $CLUSTER_NAME

# Extract kubeconfig from Terraform output
#terraform output -raw kubeconfig > ~/.kube/config

# Verify cluster access
echo "[INFO] Verifying cluster access..."
kubectl cluster-info
kubectl get nodes

echo "SUCCESS! EKS cluster & kubeconfig configuration complete."
echo ""
