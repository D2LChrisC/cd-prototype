#!/usr/bin/env bash

# set AWS credentials
echo "Setting AWS credentials..."
aws configure set aws_access_key_id $2
aws configure set aws_secret_access_key $3
aws configure set default.region us-east-1
aws configure set s3.signature_version s3v4

# log into ECR
echo "Logging into AWS ECR..."
$(aws ecr get-login --region us-east-1)

# tag and publish our latest stable build
echo "Tagging and pushing docker image..."
docker tag $4:latest $1.dkr.ecr.us-east-1.amazonaws.com/$4:latest
docker push $1.dkr.ecr.us-east-1.amazonaws.com/$4:latest

echo "Getting Terraform assets from S3..."
mkdir terraform
aws s3 sync s3://d2l-docbuilder-terraform-$1 ./terraform
unzip ./terraform/terraform.zip -d ./terraform

echo "Deploying environments..."
cd terraform
for d in */ ; do
	cd $d
	../terraform plan
	cd ..
done
