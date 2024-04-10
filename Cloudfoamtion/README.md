
### STEP-1 :: Create CloudFormation Templates 
- Templates
  - VPCT2Network.yml
  - PrivateHostedZone.yml
  - NetworkAcl.yml
  - SecurityGroupStack.yml
  - PermissionsBoundary.yml
  - IAMRolesStack.yml
  - VPCFlowLog.yml

### STEP-2 :: CLI Commands for CloudFormation 

```sh
pEnvironment="dev"

#Validate Template:
aws cloudformation validate-template --region ap-south-1 --stack-name MyStack \
        --template-body file://$(pwd)/mMyStack.yml

#Create Stack:
aws cloudformation create-stack --region ap-south-1 --stack-name MyStack \
        --template-body file://$(pwd)/mMyStack.yml \
        --parameters file://$(pwd)/workplace/$pEnvironment/MyStack.json

#Update Stack:
aws cloudformation update-stack --region ap-south-1 --stack-name MyStack \
        --template-body file://$(pwd)/mMyStack.yml \
        --parameters file://$(pwd)/workplace/$pEnvironment/MyStack.json

#Delete Stack:
aws cloudformation delete-stack --region ap-south-1 --stack-name MyStack

#Describe Stack:
aws cloudformation describe-stacks --region ap-south-1 --stack-name MyStack
```

### STEP-2 ::  Generate parameter JSON files for individual templates, each tailored to create environment-specific stacks, by utilizing shared values.
nano ./infrastructure-parameters.sh
```sh

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


StackExportPrefix="$pProject-$pEnvironment-$pResourceName"

InfraStackT2='[
  {
    "ParameterKey": "pProject",
    "ParameterValue": "'"${pProject}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pResourceName",
    "ParameterValue": "'"${pResourceName}"'"
  },
  {
    "ParameterKey": "pRootStackTemplateURL",
    "ParameterValue": "https://t3infrastructure.s3.ap-south-1.amazonaws.com/CloudFormation"
  },
  {
    "ParameterKey": "pDomainName",
    "ParameterValue": "appflow.in"
  },
  {
    "ParameterKey": "pCidrBlockVPC",
    "ParameterValue":"10.0.0.0/16"
  },
  {
    "ParameterKey": "pCidrBlockPublicSubnet1",
    "ParameterValue": "10.0.11.0/24"
  },
  {
    "ParameterKey": "pCidrBlockPublicSubnet2",
    "ParameterValue":"10.0.12.0/24"
  },
  {
    "ParameterKey": "pCidrBlockPrivateSubnet1",
    "ParameterValue":"10.0.21.0/24"
  },
  {
    "ParameterKey": "pCidrBlockPrivateSubnet2",
    "ParameterValue":"10.0.22.0/24"
  },
  {
    "ParameterKey": "pHostedZoneId",
    "ParameterValue":"Z08345961MC13X8KYMPJP"
  },
  {
    "ParameterKey": "pCertificateArn",
    "ParameterValue": "arn:aws:acm:ap-south-1:215992886516:certificate/ae64704e-396c-4ae0-9060-4211aa09c6ef"
  }
]'


echo "pProject : $pProject, pEnvironment: $pEnvironment, StackExportPrefix : $StackExportPrefix"


mkdir -p "Parameters/${pEnvironment}"
cd "Parameters/${pEnvironment}"
echo "${InfraStackT2}" > InfraStackT2.json

```

### STEP-3 ::  Validate a CLI shell script for generating environment infrastructure, utilizing CloudFormation templates.
nano ./infrastructure-validate.sh
```sh

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


```

### STEP-4 ::  Create a CLI shell script for generating environment infrastructure, utilizing CloudFormation templates and relying on a parameter JSON file for configuration.
nano ./infrastructure-create.sh
```sh
#!/usr/bin/env bash

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


```
### STEP-5 :: Execute Shell Script Cloudformation with CLI IaC for Dev Env
nano ./env_dev.sh

```sh
#!/usr/bin/env bash

pProject="project"
pEnvironment="dev"
pResourceName="t2"
pRegion="ap-south-1"


./infrastructure-parameters.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
./infrastructure-validate.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
./infrastructure-create.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}

#./infrastructure-deploy.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
#./infrastructure-delete.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}

```