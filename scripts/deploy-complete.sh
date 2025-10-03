#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting complete deployment...${NC}"

# Build Docker images
echo -e "${YELLOW}Building Docker images...${NC}"

# Build frontend
echo -e "${YELLOW}Building frontend image...${NC}"
cd src/frontend
docker build -t demo-frontend:latest .
cd ../..

# Build backend
echo -e "${YELLOW}Building backend image...${NC}"
cd src/backend
docker build -t demo-backend:latest .
cd ../..

# Load images to kind (if using kind)
if command -v kind &> /dev/null; then
    echo -e "${YELLOW}Loading images to kind cluster...${NC}"
    kind load docker-image demo-frontend:latest
    kind load docker-image demo-backend:latest
fi

# Create namespace
echo -e "${YELLOW}Creating namespace...${NC}"
kubectl create namespace demo-app --dry-run=client -o yaml | kubectl apply -f -

# Add Bitnami helm repository (for PostgreSQL)
echo -e "${YELLOW}Adding Bitnami helm repository...${NC}"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install ArgoCD if not already installed
if ! kubectl get namespace argocd &> /dev/null; then
    echo -e "${YELLOW}Installing ArgoCD...${NC}"
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    
    # Wait for ArgoCD to be ready
    echo -e "${YELLOW}Waiting for ArgoCD to be ready...${NC}"
    kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s
fi

# Apply ArgoCD application
echo -e "${YELLOW}Deploying application with ArgoCD...${NC}"
kubectl apply -f argocd/application.yaml

# Wait for application to sync
echo -e "${YELLOW}Waiting for application to sync...${NC}"
sleep 10

# Get ArgoCD admin password
echo -e "${GREEN}Deployment completed!${NC}"
echo -e "${YELLOW}ArgoCD Admin Password:${NC}"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

echo -e "${YELLOW}To access ArgoCD UI:${NC}"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"

echo -e "${YELLOW}To access the application:${NC}"
echo "Add '127.0.0.1 demo-app.local' to /etc/hosts"
echo "kubectl port-forward svc/demo-app-frontend -n demo-app 8081:80"
echo "Then visit: http://demo-app.local:8081"