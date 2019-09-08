#!/usr/bin/env bash

# Build, package, deploy sam template

#set -x

export BUCKET_NAME

# validate
sam validate --template template.yaml
aws cloudformation validate-template \
  --template-body file://template.yaml

# build, package, deploy
time sam build

time sam package \
  --output-template-file packaged.yaml \
  --s3-bucket "${BUCKET_NAME}"

time sam deploy \
  --template-file packaged.yaml \
  --stack-name iot-dynamodb \
  --capabilities CAPABILITY_IAM

# catch error - cloudformation returns code 255
# (exit non-zero) if stack exists
if [ "$?" -eq 255 ]
then
    echo "No changes to deploy."
    true
fi