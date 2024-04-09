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


# InfraStackT2
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/InfraStackT2.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi

#NaclEntryStackPublic
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/NaclEntryStackPublic.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi

#NaclEntryStackPrivate
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/NaclEntryStackPrivate.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi

#SecurityGroupStack
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/SecurityGroupStack.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi
#IAMRolesStack
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/IAMRolesStack.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi


# PrivateHostedZone
aws cloudformation validate-template --region ${pRegion} \
                     --template-body file://$(pwd)/Templates/PrivateHostedZone.yml
if [ $? -eq 0 ]; then
  echo "Validation of the CloudFormation template Success."
else
  echo "Validation of the CloudFormation template failed."
fi