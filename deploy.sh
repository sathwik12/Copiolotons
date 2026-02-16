#!/bin/bash

# 1. Capture the "Fingerprint" (Git Short SHA)
export GIT_SHA=$(git rev-parse --short HEAD)

# 2. Capture the "Label" (Semantic Version from .env)
# This assumes you added APP_VERSION=1.0.1 to your .env
export APP_VERSION=$(grep APP_VERSION .env | cut -d '=' -f2)

echo "🚀 Starting Production-Grade Deployment"
echo "📦 Version: $APP_VERSION"
echo "🆔 Commit:  $GIT_SHA"

# 3. Execute build with specific tags
# --build-arg passes data into the Dockerfile
# -d runs in detached mode
docker-compose up -d --build

echo "✅ Deployment successful. Image tagged as survey_app:$APP_VERSION-$GIT_SHA"
