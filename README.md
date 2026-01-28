# EKS Cluster Setup Scripts

Using Bash scripts, this modular setup automates the creation of an EKS cluster and essential add-ons.  

## Prerequisites:  
- Ubuntu/Debian-based system
- AWS account with appropriate permissions
- AWS SSH key pair 

## Setup Instructions:

1. Clone this repository:  
```
git clone https://github.com/Lily-G1/eks-setup.git
cd eks-setup
```  

2. Edit configuration file with your values:  
```
nano config.env
```  

4. Make all scripts executable:  
```
chmod +x *.sh
```

5. Run scripts (in the same order):  
```
# Install prerequisites  
 ./01-prerequisites.sh  

# Setup AWS CLI (requires manual input). Follow instructions to run 'aws configure' and enter AWS Access & Secret Keys when prompted  
./02-aws-setup.sh  

# Install tools  
./03-tools-install.sh  

# Create cluster (choose method)  
./04-cluster-create.sh  

# Install add-ons  
./05-addons-setup.sh 

# Verify installation  
./06-verification.sh  
```
5. Cleanup - Delete all provisioned resources with either of the following:
```  
# If created with eksctl:  
eksctl delete cluster --region "your AWS region" --name "your cluster name"  

# If created with Terraform:  
cd terraform && terraform destroy  
```
