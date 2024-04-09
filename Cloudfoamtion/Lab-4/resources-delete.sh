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


# describe and delete HostedZoneRecordSet
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-HostedZoneRecordSet" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-HostedZoneRecordSet"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-HostedZoneRecordSet"





# describe and delete  PublicLoadBalancer
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-PublicLoadBalancer" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-PublicLoadBalancer"

# describe and delete  PrivateLoadBalancer
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateLoadBalancer" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateLoadBalancer"


# wait for PublicLoadBalancer,PrivateLoadBalancer
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-PublicLoadBalancer"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateLoadBalancer"




# describe and delete  Web-LT-TG-A
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-LT-TG-AS" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-LT-TG-AS"


# describe and delete  App1-LT-TG-AS
aws cloudformation describe-stacks --region ${pRegion} --stack-name "$pProject-$pEnvironment-App1-LT-TG-AS" --query "Stacks[0].{Name:StackName,Status:StackStatus,CreationTime:CreationTime}"
aws cloudformation delete-stack --region ${pRegion} --stack-name "$pProject-$pEnvironment-App1-LT-TG-AS"

# wait for Web-LT-TG-A,App1-LT-TG-AS
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-LT-TG-AS"
aws cloudformation wait stack-delete-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-App1-LT-TG-AS"

# get stacks list
aws cloudformation list-stacks --query "StackSummaries[?StackStatus!='DELETE_COMPLETE'].{Name:StackName,Status:StackStatus}"