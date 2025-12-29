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

# Создаём директорию для unit (если не существует)
sudo mkdir -p /etc/systemd/system

# Копируем unit файл на AMI
sudo cp "${AMI_TEMP_PATH}/${SERVICE_FILE_NAME}" /etc/systemd/system/application.service

# Перезагружаем systemd и включаем сервис
sudo systemctl daemon-reload
sudo systemctl enable application.service
sudo systemctl start application.service

echo "[INFO] systemd service 'application' installed"
