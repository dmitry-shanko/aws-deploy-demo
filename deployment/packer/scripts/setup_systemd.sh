#!/bin/bash
set -e

# Проверяем переменные
if [[ -z "$AMI_JAR_PATH" ]]; then
  echo "[ERROR] AMI_JAR_PATH is not set"
  exit 1
fi

if [[ -z "$AMI_TEMP_PATH" ]]; then
  echo "[ERROR] AMI_TEMP_PATH is not set"
  exit 1
fi

if [[ -z "$SERVICE_FILE_NAME" ]]; then
  echo "[ERROR] SERVICE_FILE_NAME is not set"
  exit 1
fi

if [[ -z "$JVM_OPTIONS_FILE" ]]; then
  echo "[ERROR] JVM_OPTIONS_FILE is not set"
  exit 1
fi

TEMPLATE_FILE="$AMI_TEMP_PATH/$SERVICE_FILE_NAME"
SERVICE_FILE="/etc/systemd/system/application.service"
JVM_OPTIONS_PATH="/etc/trade-signals-app"
JVM_OPTIONS_FULL_PATH="$JVM_OPTIONS_PATH/$JVM_OPTIONS_FILE"

# Создаём директорию для unit (если не существует)
sudo mkdir -p /etc/systemd/system

sudo mkdir -p "$JVM_OPTIONS_PATH"

# Обновляем jar в service конфиге
sudo sh -c "AMI_JAR_PATH='$AMI_JAR_PATH' envsubst < '$TEMPLATE_FILE' > '$SERVICE_FILE'"

sudo mv "$AMI_TEMP_PATH"/"$JVM_OPTIONS_FILE" "$JVM_OPTIONS_FULL_PATH"

echo "[INFO] Copied systemd config from '$TEMPLATE_FILE' to '$SERVICE_FILE'"
echo "[INFO] Copied jvm.options from '$AMI_TEMP_PATH'/'$JVM_OPTIONS_FILE' to '$JVM_OPTIONS_FULL_PATH'"
echo "[INFO] AMI_JAR_PATH='$AMI_JAR_PATH'"

sudo chmod 644 "$SERVICE_FILE"

# Не запускаем сервис, пока AMI строится
sudo systemctl daemon-reload
sudo systemctl enable application.service

echo "[INFO] systemd unit installed but NOT started (correct for Packer AMI build)"
