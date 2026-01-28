#!/bin/bash

set -e

echo "==========================================="
echo "Step 5: Installing EKS Add-ons"
echo "==========================================="

source ./config.env

# Verify cluster connectivity
echo "[INFO] Checking cluster connectivity..."
kubectl cluster-info


# Associate IAM OIDC Provider
echo "[INFO] Associating IAM OIDC Provider with EKS cluster..."
eksctl utils associate-iam-oidc-provider \
    --region $AWS_REGION \
    --cluster $CLUSTER_NAME \
    --approve


# Create IAM Service Account for EBS CSI Driver
echo "[INFO] Creating IAM Service Account for EBS CSI Driver..."
eksctl create iamserviceaccount \
    --region $AWS_REGION \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster $CLUSTER_NAME \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve \
    --override-existing-serviceaccounts


# Install EBS CSI Driver
echo "[INFO] Deploying EBS CSI Driver..."
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.11"


# Wait for EBS CSI Driver to be ready
echo "[INFO] Waiting for EBS CSI Driver to be ready..."
kubectl wait --namespace kube-system \
    --for=condition=available deployment/ebs-csi-controller \
    --timeout=300s


# Install NGINX Ingress Controller
echo "[INFO] Deploying NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml


# Wait for ingress controller
echo "[INFO] Waiting for NGINX Ingress Controller..."
kubectl wait --namespace ingress-nginx \
    --for=condition=available deployment/ingress-nginx-controller \
    --timeout=300s


# Get LoadBalancer URL
INGRESS_LB=$(kubectl -n ingress-nginx get service ingress-nginx-controller \
    -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "Pending")
echo "[INFO] Ingress LoadBalancer: $INGRESS_LB"


# Install cert-manager
echo "[INFO] Deploying cert-manager ${CERT_MANAGER_VERSION}..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml


# Wait for cert-manager
echo "[INFO] Waiting for cert-manager to be ready..."
sleep 10     # Give it time to start
kubectl wait --namespace cert-manager \
    --for=condition=available deployment/cert-manager \
    --timeout=300s


echo "SUCCESS! All add-ons installed."
echo ""
