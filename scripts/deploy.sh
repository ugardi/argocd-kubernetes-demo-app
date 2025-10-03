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
docker build -t your-registry/demo-frontend:latest ./src/frontend
docker build -t your-registry/demo-backend:latest ./src/backend

echo -e "${YELLOW}Pushing images to registry...${NC}"
docker push your-registry/demo-frontend:latest
docker push your-registry/demo-backend:latest

# Create namespace
echo -e "${YELLOW}Creating namespace...${NC}"
kubectl apply -f k8s/namespace.yaml

# Install ArgoCD application
echo -e "${YELLOW}Deploying with ArgoCD...${NC}"
kubectl apply -f argocd/application.yaml

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}Check ArgoCD UI for sync status.${NC}"
