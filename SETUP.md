# ArgoCD GitOps Setup Guide

This guide will help you set up ArgoCD with Kustomize and Application of Applications pattern for the Simple Python App.

## 📋 Prerequisites

- Kubernetes cluster (Docker Desktop, minikube, or cloud)
- kubectl configured
- Git repository access
- Docker for building images

## 🚀 Quick Start

### 1. Install ArgoCD

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Install ArgoCD
./scripts/install-argocd.sh
```

### 2. Deploy Applications

```bash
# Deploy all applications
./scripts/deploy-applications.sh
```

### 3. Access ArgoCD UI

```bash
# Port forward to ArgoCD (if not already running)
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access: https://localhost:8080
- Username: `admin`
- Password: (see terminal output from install script)

## 🏗️ Architecture

### Repository Structure
```
simple-python-app-devops/
├── argocd/                    # ArgoCD Application definitions
│   ├── app-of-apps.yaml      # Root Application of Applications
│   └── applications/         # Individual application definitions
├── base/                     # Kustomize base configurations
├── environments/             # Environment-specific overlays
│   ├── dev/
│   ├── staging/
│   └── prod/
└── scripts/                  # Setup and utility scripts
```

### Application of Applications Pattern
- **Root App**: `app-of-apps.yaml` manages all environment applications
- **Environment Apps**: Each environment has its own ArgoCD application
- **Kustomize Overlays**: Environment-specific configurations

## 🔄 Workflow

### Automated Workflow
1. **Code Push** → GitHub Actions triggers
2. **Docker Build** → New image with SHA1 tag
3. **Update Image Tag** → Update environment-specific files
4. **ArgoCD Sync** → Automatically deploys new image

### Manual Workflow
```bash
# Update specific environment
./scripts/update-image-tag.sh dev ac599aa

# Update all environments
./scripts/update-image-tag.sh dev $(git rev-parse --short HEAD)
```

## 🌍 Environments

### Development (dev)
- **Namespace**: `simple-python-app-dev`
- **Replicas**: 1
- **Resources**: 250m CPU, 256Mi memory
- **Auto-sync**: Enabled

### Staging (staging)
- **Namespace**: `simple-python-app-staging`
- **Replicas**: 2
- **Resources**: 500m CPU, 512Mi memory
- **Auto-sync**: Enabled

### Production (prod)
- **Namespace**: `simple-python-app-prod`
- **Replicas**: 3
- **Resources**: 1000m CPU, 1Gi memory
- **Auto-sync**: Disabled (manual approval required)

## 🛠️ Management Commands

### Check Application Status
```bash
# All applications
kubectl get applications -n argocd

# Specific environment
kubectl get all -n simple-python-app-dev
```

### Manual Sync
```bash
# Sync specific application
kubectl patch application simple-python-app-dev -n argocd --type merge -p '{"operation":{"sync":{}}}'

# Sync all applications
kubectl get applications -n argocd -o name | xargs -I {} kubectl patch {} -n argocd --type merge -p '{"operation":{"sync":{}}}'
```

### Update Image Tag
```bash
# Update dev environment
./scripts/update-image-tag.sh dev ac599aa

# Update staging environment
./scripts/update-image-tag.sh staging ac599aa

# Update production environment
./scripts/update-image-tag.sh prod ac599aa
```

## 🔧 Troubleshooting

### Check ArgoCD Logs
```bash
kubectl logs -n argocd deployment/argocd-server
kubectl logs -n argocd deployment/argocd-application-controller
```

### Check Application Sync Status
```bash
kubectl describe application simple-python-app-dev -n argocd
```

### Force Sync
```bash
kubectl patch application simple-python-app-dev -n argocd --type merge -p '{"operation":{"sync":{"syncOptions":["Force=true"]}}}'
```

## 📊 Monitoring

### ArgoCD UI
- Access: https://localhost:8080
- View application status, sync history, and resource details

### Command Line
```bash
# Application status
kubectl get applications -n argocd -o wide

# Resource status
kubectl get all -n simple-python-app-dev
kubectl get all -n simple-python-app-staging
kubectl get all -n simple-python-app-prod
```

## 🎯 Benefits

- ✅ **GitOps**: Everything version controlled in Git
- ✅ **Multi-Environment**: Separate dev, staging, prod
- ✅ **Automated**: Image updates trigger automatic deployments
- ✅ **Kustomize**: Environment-specific configurations
- ✅ **Application of Applications**: Centralized management
- ✅ **Auditable**: Full history of changes
- ✅ **Rollback**: Easy to revert to previous versions
