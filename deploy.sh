#!/bin/bash
set -e

# ====== Settings ======
GROUP_ID="com.example"
ARTIFACT_ID="aws-deploy-demo"
VERSION="0.0.1-SNAPSHOT"
PACKAGING="jar"
APP_PORT=80
INSTANCE_TYPE=t3.micro

# Local Maven repo
LOCAL_REPO="${HOME}/telegram-signals-builds"

# CloudFormation settings
STACK_NAME="springboot-ec2-deployment"
TEMPLATE_FILE="ec2-template.yaml"

# S3 bucket
BUCKET_NAME="my-spring-boot-app-bucket-2025-12-23-14-55"

ARTIFACT_DIR="$LOCAL_REPO/$(echo $GROUP_ID | tr '.' '/')/$ARTIFACT_ID/$VERSION"
ARTIFACT_PATH=$(ls -t "$ARTIFACT_DIR"/*.jar | head -n 1)

if [ ! -f "$ARTIFACT_PATH" ]; then
  echo "Error: artifact not found in $ARTIFACT_DIR"
  exit 1
fi

echo "Artifact found: $ARTIFACT_PATH"

# Artifact name
ARTIFACT_KEY=$(basename "$ARTIFACT_PATH")

# ====== S3 ======
echo "Uploading $ARTIFACT_PATH to s3://$BUCKET_NAME/$ARTIFACT_KEY"
aws s3 cp "$ARTIFACT_PATH" "s3://$BUCKET_NAME/$ARTIFACT_KEY"

# ====== CloudFormation ======
echo "CloudFormation deployment..."
aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --parameter-overrides ArtifactBucket="$BUCKET_NAME" ArtifactKey="$ARTIFACT_KEY" InstanceType=$INSTANCE_TYPE AppPort=$APP_PORT \
  --capabilities CAPABILITY_NAMED_IAM \
  --disable-rollback

# ====== Receiving ID and URL of new instance ======
INSTANCE_ID=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='AppEC2InstanceId'].OutputValue" \
  --output text)

PUBLIC_IP=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='PublicIP'].OutputValue" \
  --output text)

URL=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='URL'].OutputValue" \
  --output text)

echo "EC2 Instance ID: $INSTANCE_ID"

echo "Application Deployed: $URL"

# ====== Health Check ======
echo "Checking Health Check"
until curl -s "$URL/api/health-check" | grep -q "SUCCESS"; do
  echo "Waiting for Health Check..."
  sleep 5
done

echo "Application is running! URL: $URL"


# Rollback command:
# aws cloudformation delete-stack --stack-name springboot-ec2-deployment
# Check command:
# aws cloudformation describe-stack-events --stack-name springboot-ec2-deployment