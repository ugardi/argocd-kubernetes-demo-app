# Cloud Native Kubernetes Demo Application

A comprehensive cloud-native web application demonstrating Kubernetes and ArgoCD deployment with GitOps practices.

## Architecture

- **Frontend**: React.js SPA
- **Backend**: Node.js Express API
- **Database**: PostgreSQL
- **Orchestration**: Kubernetes with Helm
- **GitOps**: ArgoCD

## Quick Start

### Prerequisites

- Kubernetes cluster
- kubectl
- Helm
- ArgoCD CLI
- Docker

### Deployment

1. **Install ArgoCD**
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
