#!/bin/bash
# Usage: ./deploy.sh dev OR ./deploy.sh prod

ENV=${1:-dev}
export GIT_SHA=$(git rev-parse --short HEAD)
export APP_PROFILE=$ENV

# Determine if we should use 'docker compose' or 'docker-compose'
if docker compose version > /dev/null 2>&1; then
    DOCKER_CMD="docker compose"
else
    DOCKER_CMD="docker-compose"
fi

echo "🚀 Deploying with [$ENV] profile using $DOCKER_CMD..."

if [ "$ENV" == "prod" ]; then
    $DOCKER_CMD -f docker-compose.yml -f docker-compose.prod.yml up -d --build
else
    $DOCKER_CMD up -d --build
fi

echo "✅ Deployment successful!"
