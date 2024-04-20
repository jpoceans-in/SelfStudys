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


# describe and delete App-Instance
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-App-Instance" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-App-Instance"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-App-Instance"


# describe and delete Web-Instance
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-Instance" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-Instance"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-Instance"




# describe and delete NaclEntryStackPrivate
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPrivate" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPrivate"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPrivate"


# describe and delete NaclEntryStackPublic
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPublic" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPublic"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPublic"


# describe and delete SecurityGroupStack
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-SecurityGroupStack" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-SecurityGroupStack"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-SecurityGroupStack"


# describe and delete IAMRolesStack
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-IAMRolesStack" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-IAMRolesStack"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-IAMRolesStack"


# describe and delete InfraStackT2
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2"





# get stacks list
aws cloudformation list-stacks --query "StackSummaries[?StackStatus!='DELETE_COMPLETE'].{Name:StackName,Status:StackStatus}"
