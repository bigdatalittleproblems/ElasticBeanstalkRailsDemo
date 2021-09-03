#!/bin/bash
set -eo pipefail
ARTIFACT_BUCKET=$(cat bucket-name.txt)
DB_Password=$(dd if=/dev/random bs=8 count=1 2>/dev/null | od -An -tx1 | tr -d ' \t\n')
echo "password is: $DB_Password"
git archive --format=zip HEAD >package.zip
aws cloudformation package --template-file template.yml --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yml
# aws cloudformation create-stack --stack-name demostack --s3-bucket https://$ARTIFACT_BUCKET.s3.amazonaws.com  --region us-west-1 --capabilities CAPABILITY_NAMED_IAM --capabilities CAPABILITY_IAM --parameters ParameterKey=DBPassword,ParameterValue=$DB_Password
aws cloudformation deploy --template-file out.yml --stack-name ebtest \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides DBPassword=$DB_Password
# ARTIFACT_BUCKET=$(cat bucket-name.txt) && aws s3 rb --force s3://$ARTIFACT_BUCKET