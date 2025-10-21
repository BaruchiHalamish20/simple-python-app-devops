#!/bin/bash

# ArgoCD Installation Script
set -e

echo "🚀 Installing ArgoCD..."

# Create ArgoCD namespace
# kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install ArgoCD
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
# echo "⏳ Waiting for ArgoCD to be ready..."
# kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Get ArgoCD admin password
echo "🔑 ArgoCD Admin Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Port forward ArgoCD server
# echo "🌐 Starting port-forward to ArgoCD server..."
# echo "Access ArgoCD UI at: https://localhost:8080"
# echo "Username: admin"
# echo "Password: (see above)"
# echo ""
# echo "Press Ctrl+C to stop port-forward"

# kubectl port-forward svc/argocd-server -n argocd 8080:443
