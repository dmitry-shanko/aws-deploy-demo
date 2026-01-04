#!/bin/bash
set -e

### Обновление системы
sudo yum update -y

### Установка Java 17 (Amazon Corretto)
sudo yum install -y java-17-amazon-corretto-headless

### Установка awslogs (старый агент CloudWatch Logs)
sudo yum install -y awslogs

### Установка нового CloudWatch Agent
sudo yum install -y amazon-cloudwatch-agent

echo "[INFO] Installed all required dependencies"