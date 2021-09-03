#!/bin/bash
aws cloudformation delete-stack --stack-name ebtest 
ARTIFACT_BUCKET=$(cat bucket-name.txt) && aws s3 rb --force s3://$ARTIFACT_BUCKET