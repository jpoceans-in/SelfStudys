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

aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2" \
                     --template-body file://$(pwd)/Templates/InfraStackT2.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/InfraStackT2.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-InfraStackT2"

# wait for InfraStackT2
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-InfraStackT2"



# create NaclEntryStackPrivate
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPrivate" \
                     --template-body file://$(pwd)/Templates/NaclEntryStackPrivate.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/NaclEntryStackPrivate.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-NaclEntryStackPrivate"

# create NaclEntryStackPublic
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-NaclEntryStackPublic" \
                     --template-body file://$(pwd)/Templates/NaclEntryStackPublic.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/NaclEntryStackPublic.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-NaclEntryStackPublic"


# create SecurityGroupStack
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-SecurityGroupStack" \
                     --template-body file://$(pwd)/Templates/SecurityGroupStack.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/SecurityGroupStack.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-SecurityGroupStack"

# create IAMRolesStack
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-IAMRolesStack" \
                     --template-body file://$(pwd)/Templates/IAMRolesStack.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/IAMRolesStack.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-IAMRolesStack"

# create PrivateHostedZone
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateHostedZone" \
                     --template-body file://$(pwd)/Templates/PrivateHostedZone.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/PrivateHostedZone.json \
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