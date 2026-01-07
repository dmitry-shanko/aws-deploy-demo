#!/bin/bash
set -e

VPC_ID="$1"
SUBNET_ID="$2"
SG_ID="$3"
IAM_PROFILE="$4"
INSTANCE_TYPE="$5"
ELASTIC_IP_ID="$6"
KEY_NAME="$7"

cd "$(dirname "$0")/terraform"

echo "[INFO] Running Terraform with:"
echo "  VPC: $VPC_ID"
echo "  Subnet: $SUBNET_ID"
echo "  SG: $SG_ID"
echo "  IAM Profile: $IAM_PROFILE"
echo "  Instance Type: $INSTANCE_TYPE"
echo "  Elastic IP: $ELASTIC_IP_ID"
echo "  Key: $KEY_NAME"

terraform init -input=false

terraform apply -input=false -auto-approve \
  -var="vpc_id=$VPC_ID" \
  -var="subnet_id=$SUBNET_ID" \
  -var="security_group_id=$SG_ID" \
  -var="instance_profile=$IAM_PROFILE" \
  -var="instance_type=$INSTANCE_TYPE" \
  -var="elastic_ip_id=$ELASTIC_IP_ID" \
  -var="key_name=$KEY_NAME"