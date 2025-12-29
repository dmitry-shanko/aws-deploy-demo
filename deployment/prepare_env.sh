#!/bin/bash
set -e

GROUP_ID="$1"
ARTIFACT_ID="$2"
VERSION="$3"
LOCAL_REPO="$4"
ENV_FILE="$5"

mkdir -p "$(dirname "$ENV_FILE")"

# Преобразуем groupId в путь
GROUP_PATH=$(echo "$GROUP_ID" | tr '.' '/')

ARTIFACT_DIR="${LOCAL_REPO}/${GROUP_PATH}/${ARTIFACT_ID}/${VERSION}"

if [[ ! -d "$ARTIFACT_DIR" ]]; then
  echo "Artifact directory not found: $ARTIFACT_DIR"
  exit 1
fi

JAR=$(ls -1t "${ARTIFACT_DIR}"/*.jar | head -n1)

if [[ -z "$JAR" ]]; then
  echo "No JAR file found in $ARTIFACT_DIR"
  exit 1
fi

echo "LOCAL_JAR_PATH=${JAR}" > "$ENV_FILE"
echo "[INFO] Generated $ENV_FILE"
echo "[INFO] Using JAR: $JAR"
