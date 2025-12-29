#!/bin/bash

if [[ -z "$AMI_TEMP_PATH" ]]; then
  echo "[ERROR] AMI_TEMP_PATH is not set"
  exit 1
fi

sudo rm -rf "$AMI_TEMP_PATH"/*
