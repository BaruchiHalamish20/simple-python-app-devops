#!/bin/bash

# Manual Image Tag Update Script
set -e

ENVIRONMENT=${1:-dev}
IMAGE_TAG=${2:-$(git rev-parse --short HEAD)}

if [ -z "$ENVIRONMENT" ] || [ -z "$IMAGE_TAG" ]; then
    echo "Usage: $0 <environment> [image_tag]"
    echo "Environments: dev, staging, prod"
    echo "If image_tag is not provided, current git SHA will be used"
    exit 1
fi

echo "🔄 Updating $ENVIRONMENT environment with image tag: $IMAGE_TAG"

# Update kustomization.yaml
sed -i "s/newTag: .*/newTag: $IMAGE_TAG/" environments/$ENVIRONMENT/kustomization.yaml

# Update image-tag.yaml
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
sed -i "s/IMAGE_TAG: \".*\"/IMAGE_TAG: \"$IMAGE_TAG\"/" environments/$ENVIRONMENT/image-tag.yaml
sed -i "s/LAST_UPDATED: \".*\"/LAST_UPDATED: \"$TIMESTAMP\"/" environments/$ENVIRONMENT/image-tag.yaml

echo "✅ Updated $ENVIRONMENT environment configuration"
echo "📝 Changes:"
echo "  - Image tag: $IMAGE_TAG"
echo "  - Updated: $TIMESTAMP"

# Commit changes
git add environments/$ENVIRONMENT/
git commit -m "Update image tag to $IMAGE_TAG for $ENVIRONMENT environment"
git push

echo "🚀 Changes committed and pushed to repository"
echo "🔄 ArgoCD will automatically sync the changes"
