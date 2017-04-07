#!/usr/bin/env bash

# set AWS credentials
aws configure set aws_access_key $2
aws configure set aws_secret_access_key $3
aws configure set default.region us-east-1

# log into ECR
$(aws ecr get-login --region us-east-1)

# tag and publish our latest stable build
docker tag $4:latest $1.dkr.ecr.us-east-1.amazonaws.com/$4:latest
docker push $1.dkr.ecr.us-east-1.amazonaws.com/$4:latest
