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

if [[ -z "$CLOUDWATCH_CONFIG_FILE_NAME" ]]; then
  echo "[ERROR] CLOUDWATCH_CONFIG_FILE_NAME is not set"
  exit 1
fi

LOG_DIR="/var/log/trade-signals-app"
CONFIG_SOURCE="$AMI_TEMP_PATH/$CLOUDWATCH_CONFIG_FILE_NAME"
CONFIG_DEST="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"

echo "[INFO] Using JAR: $AMI_JAR_PATH"
echo "[INFO] Using config CloudWatch: $CLOUDWATCH_CONFIG_FILE_NAME"

# Создаем директорию для логов
sudo mkdir -p "$LOG_DIR"

# Создаем директорию для конфигурации CloudWatch Agent
sudo mkdir -p "$(dirname "$CONFIG_DEST")"

# Копируем конфиг в место, откуда CloudWatch Agent его прочитает
sudo cp "$CONFIG_SOURCE" "$CONFIG_DEST"

# Запускаем CloudWatch Agent с конфигом
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:"$CONFIG_DEST" \
  -s