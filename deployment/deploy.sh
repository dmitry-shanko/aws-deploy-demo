#!/bin/bash
set -e

ENV_FILE="$1"

if [[ -z "$ENV_FILE" ]]; then
  echo "Usage: deploy.sh <path-to-env>"
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "deploy.env file not found: $ENV_FILE"
  exit 1
fi

source "$ENV_FILE"

echo "[INFO] LOCAL_JAR_PATH = $LOCAL_JAR_PATH"

LOCAL_JAR_NAME=$(basename "$LOCAL_JAR_PATH")

echo "[INFO] LOCAL_JAR_NAME = $LOCAL_JAR_NAME"

packer build \
  -var "local_jar_path=$LOCAL_JAR_PATH" \
  -var "local_jar_name=$LOCAL_JAR_NAME" \
  deployment/packer/packer.pkr.hcl
