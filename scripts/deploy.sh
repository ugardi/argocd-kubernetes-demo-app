#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting deployment...${NC}"

# Build and push images
echo -e "${YELLOW}Building Docker images...${NC}"

# Build frontend
echo -e "${YELLOW}Building frontend...${NC}"
cd src/frontend
docker build -t ugardi/demo-frontend:latest .
cd ../..

# Build backend
echo -e "${YELLOW}Building backend...${NC}"
cd src/backend
docker build -t ugardi/demo-backend:latest .
cd ../..

echo -e "${YELLOW}Pushing images to registry...${NC}"
# Uncomment if you have a registry setup
# docker push ugardi/demo-frontend:latest
# docker push ugardi/demo-backend:latest

# Create namespace
echo -e "${YELLOW}Creating namespace...${NC}"
kubectl apply -f k8s/namespace.yaml

# Install ArgoCD application
echo -e "${YELLOW}Deploying with ArgoCD...${NC}"
kubectl apply -f argocd/application.yaml

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}Check ArgoCD UI for sync status.${NC}"

# Get ArgoCD admin password
echo -e "${YELLOW}ArgoCD admin password:${NC}"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo