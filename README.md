# EKS Cluster Setup Scripts

Using Bash scripting, this modular setup automates the creation of an EKS cluster and its essential add-ons.

## Prerequisites:
- Ubuntu/Debian-based system
- AWS account with appropriate permissions
- SSH key pair (for EC2 instances)

## Setup Instructions:

### 1. Clone this repo for the scripts:
git clone https://github.com/Lily-G1/eks-setup.git
cd eks-setup

??mkdir eks-setup && cd eks-setup

### 2. Edit configuration file with your values:
nano config.env

### 3. Make all scripts executable:
chmod +x *.sh

### 4. Run scripts (in the same order):
#Install prerequisites
./01-prerequisites.sh

#Setup AWS CLI (requires manual input). Follow instructions to run 'aws configure'
./02-aws-setup.sh

#Install tools
./03-tools-install.sh

#Create cluster (choose method)
./04-cluster-create.sh

#Install add-ons
./05-addons-setup.sh

#Verify installation
./06-verification.sh

### 5. Cleanup - Delete cluster with either of the following:  
# If created with eksctl
eksctl delete cluster --region "your aws region here" --name "your cluster name here"

# If created with Terraform
cd terraform && terraform destroy
