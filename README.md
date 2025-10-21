# Simple Python App - DevOps Repository

This repository contains the GitOps configuration for deploying the simple-python-app across different environments.

## Structure

```
.
├── base/                    # Base Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── environments/            # Environment-specific overlays
    ├── dev/
    │   ├── kustomization.yaml
    │   └── image-tag.yaml
    ├── staging/
    │   ├── kustomization.yaml
    │   └── image-tag.yaml
    └── prod/
        ├── kustomization.yaml
        └── image-tag.yaml
```

## Environments

- **dev**: Development environment (auto-deploy on cursor branch)
- **staging**: Staging environment (auto-deploy on main branch)
- **prod**: Production environment (manual approval required)

## Image Tags

Image tags are automatically updated by GitHub Actions from the application repository.

## Deployment

Each environment uses Kustomize to overlay base configurations:

```bash
# Deploy to dev
kubectl apply -k environments/dev

# Deploy to staging
kubectl apply -k environments/staging

# Deploy to prod
kubectl apply -k environments/prod
```

## ArgoCD Integration

This repository is designed to work with ArgoCD for GitOps deployment:

1. ArgoCD watches this repository for changes
2. When image tags are updated by CI/CD, ArgoCD detects the change
3. ArgoCD automatically syncs the changes to the cluster
