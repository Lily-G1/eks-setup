#!/bin/bash

echo "==========================================="
echo "Step 6: Verification Summary"
echo "==========================================="

source ./config.env

echo "Installation Summary:"
echo "-----------------------"
echo "✓ AWS CLI: $(aws --version 2>/dev/null | head -1)"
echo "✓ Terraform: $(terraform version 2>/dev/null | head -n 1)"
echo "✓ kubectl: $(kubectl version --client --short 2>/dev/null | awk '{print $3}')"
echo "✓ eksctl: $(eksctl version 2>/dev/null | head -n 1)"
echo ""

echo "EKS Cluster Status:"
echo "---------------------"
echo "Cluster: $CLUSTER_NAME"
echo "Region: $AWS_REGION"

# Check cluster status
if kubectl cluster-info >/dev/null 2>&1; then
    echo "✓ Cluster is accessible"
    
    # Get node count
    NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
    echo "✓ Number of nodes: $NODE_COUNT"
    
    # Get add-on status
    echo ""
    echo "Add-on Status:"
    echo "---------------"
    
    # Check EBS CSI
    if kubectl -n kube-system get deployment ebs-csi-controller >/dev/null 2>&1; then
        echo "✓ EBS CSI Driver: Running"
    else
        echo "✗ EBS CSI Driver: Not found"
    fi
    
    # Check NGINX Ingress
    if kubectl -n ingress-nginx get deployment ingress-nginx-controller >/dev/null 2>&1; then
        echo "✓ NGINX Ingress: Running"
    else
        echo "✗ NGINX Ingress: Not found"
    fi
    
    # Check cert-manager
    if kubectl -n cert-manager get deployment cert-manager >/dev/null 2>&1; then
        echo "✓ cert-manager: Running"
    else
        echo "✗ cert-manager: Not found"
    fi
else
    echo "✗ Cluster is not accessible"
fi

echo ""
echo "==========================================="
echo "Setup Complete!"
echo "==========================================="
echo ""
