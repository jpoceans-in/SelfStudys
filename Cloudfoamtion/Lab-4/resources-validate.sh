#!/usr/bin/env bash


# Define the parameters as variables
pProject=""
pEnvironment=""
pResourceName=""
pRegion=""

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -p)
      pProject=$2
      shift 2
      ;;
    -e)
      pEnvironment=$2
      shift 2
      ;;
    -rn)
    pResourceName=$2
      shift 2
      ;;
    -r)
      pRegion=$2
      shift 2
      ;;
  esac
done


# Web-LT-TG-AS
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/Resources/Web-LT-TG-AS.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi

# App1-LT-TG-AS
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/Resources/App1-LT-TG-AS.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi

# PublicLoadBalancer
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/Resources/PublicLoadBalancer.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi

# PrivateLoadBalancer
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/Resources/PrivateLoadBalancer.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi
# HostedZoneRecordSet
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/Resources/HostedZoneRecordSet.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi
