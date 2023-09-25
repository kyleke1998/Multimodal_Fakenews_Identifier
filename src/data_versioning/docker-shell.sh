#!/bin/bash

set -e

export BASE_DIR=$(pwd)
export GCP_PROJECT="AC215"
export GCP_ZONE="us-central1-a"
export GCS_BUCKET_NAME="fakenew_classifier_data_bucket"

# Create the network if we don't have it yet
docker network inspect data-versioning-network >/dev/null 2>&1 || docker network create data-versioning-network

# Build the image based on the Dockerfile
docker build -t data-version-cli --platform=linux/arm64/v8 -f Dockerfile .

# Run Container
docker run --rm --name data-version-cli -ti \
-v "$BASE_DIR":/app \
-v ~/.gitconfig:/etc/gitconfig \
-e GCP_PROJECT=$GCP_PROJECT \
-e GCP_ZONE=$GCP_ZONE \
-e GCS_BUCKET_NAME=$GCS_BUCKET_NAME \
--network data-versioning-network data-version-cli