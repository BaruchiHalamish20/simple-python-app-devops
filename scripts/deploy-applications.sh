#!/bin/bash

# Deploy ArgoCD Applications Script
set -e

echo "🚀 Deploying ArgoCD Applications..."

# Apply the Application of Applications
kubectl apply -f argocd/app-of-apps.yaml

echo "⏳ Waiting for applications to be created..."
sleep 10

# Check application status
echo "📊 Application Status:"
kubectl get applications -n argocd

echo ""
echo "✅ ArgoCD Applications deployed!"
echo ""
echo "To check sync status:"
echo "kubectl get applications -n argocd"
echo ""
echo "To check application resources:"
echo "kubectl get all -n simple-python-app-dev"
echo "kubectl get all -n simple-python-app-staging"
echo "kubectl get all -n simple-python-app-prod"
