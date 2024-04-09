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

aws cloudformation deploy  --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2" \
                     --template-file ./Templates/InfraStackT2.yml \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-InfraStackT2"

# wait for InfraStackT2
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2"

# create NaclEntryStackPrivate
aws cloudformation deploy  --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPrivate" \
                     --template-file ./Templates/NaclEntryStackPrivate.yml \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-NaclEntryStackPrivate"

# create NaclEntryStackPublic
aws cloudformation deploy  --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPublic" \
                     --template-file ./Templates/NaclEntryStackPublic.yml \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-NaclEntryStackPublic"


# create SecurityGroupStack
aws cloudformation deploy  --region ${pRegion} --stack-name "$pProject-$pEnvironment-SecurityGroupStack" \
                     --template-file ./Templates/SecurityGroupStack.yml \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-SecurityGroupStack"

# create IAMRolesStack
aws cloudformation deploy  --region ${pRegion} --stack-name "$pProject-$pEnvironment-IAMRolesStack" \
                     --template-file ./Templates/IAMRolesStack.yml \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-IAMRolesStack"

# create IAMRolesStack
aws cloudformation deploy  --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateHostedZone" \
                     --template-file ./Templates/PrivateHostedZone.yml \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-PrivateHostedZone"

# wait for NaclEntryStackPrivate, NaclEntryStackPublic, SecurityGroupStack, IAMRolesStack
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPrivate"
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPublic"
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-SecurityGroupStack"
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-IAMRolesStack"
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateHostedZone"

# get stacks list
aws cloudformation list-stacks --query "StackSummaries[?StackStatus!='DELETE_COMPLETE'].{Name:StackName,Status:StackStatus}"