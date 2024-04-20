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

