#!/bin/bash
set -e

sudo mkdir -p "$AMI_APP_PATH"
sudo mv "$AMI_TEMP_PATH"/"$JAR_NAME" "$AMI_APP_PATH"/"$JAR_NAME"
sudo chmod +x "$AMI_APP_PATH"/"$JAR_NAME"