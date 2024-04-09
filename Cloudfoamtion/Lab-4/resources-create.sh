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

# create Web-LT-TG-AS
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-LT-TG-AS" \
                     --template-body file://$(pwd)/Templates/Resources/Web-LT-TG-AS.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/Web-LT-TG-AS.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-Web-LT-TG-AS"

# create App1-LT-TG-AS
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-App1-LT-TG-AS" \
                     --template-body file://$(pwd)/Templates/Resources/App1-LT-TG-AS.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/App1-LT-TG-AS.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-App1-LT-TG-AS"

# wait for Web-LT-TG-AS, App1-LT-TG-AS
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-Web-LT-TG-AS"
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-App1-LT-TG-AS"







# create PublicLoadBalancer
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-PublicLoadBalancer" \
                     --template-body file://$(pwd)/Templates/Resources/PublicLoadBalancer.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/PublicLoadBalancer.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-PublicLoadBalancer"

# create PrivateLoadBalancer
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateLoadBalancer" \
                     --template-body file://$(pwd)/Templates/Resources/PrivateLoadBalancer.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/PrivateLoadBalancer.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-PrivateLoadBalancer"

# wait for PublicLoadBalancer,PrivateLoadBalancer
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-PublicLoadBalancer"
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-PrivateLoadBalancer"




# create HostedZoneRecordSet
aws cloudformation create-stack  --region ${pRegion} --stack-name "$pProject-$pEnvironment-HostedZoneRecordSet" \
                     --template-body file://$(pwd)/Templates/Resources/HostedZoneRecordSet.yml \
                     --parameters file://$(pwd)/Parameters/${pEnvironment}/HostedZoneRecordSet.json \
                     --capabilities CAPABILITY_NAMED_IAM \
                     --tags \
                         Key=pProject,Value=${pProject} \
                         Key=pEnvironment,Value=${pEnvironment} \
                         Key=StackName,Value="$pProject-$pEnvironment-HostedZoneRecordSet"

# wait for HostedZoneRecordSet
aws cloudformation wait stack-create-complete --region ${pRegion} --stack-name "$pProject-$pEnvironment-HostedZoneRecordSet"




# get stacks list
aws cloudformation list-stacks --query "StackSummaries[?StackStatus!='DELETE_COMPLETE'].{Name:StackName,Status:StackStatus}"