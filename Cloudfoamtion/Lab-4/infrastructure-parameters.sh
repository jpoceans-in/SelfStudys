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


NaclEntryStackPublic='[
  {
    "ParameterKey": "StackExportPrefix",
    "ParameterValue": "'"${StackExportPrefix}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pNetworkAclId",
    "ParameterValue": "PublicNetworkAcl1"
  },
  {
    "ParameterKey": "pSpecificCidrBlock",
    "ParameterValue": "0.0.0.0/0"
  }
]'
NaclEntryStackPrivate='[
  {
    "ParameterKey": "StackExportPrefix",
    "ParameterValue": "'"${StackExportPrefix}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pNetworkAclId",
    "ParameterValue": "PrivateNetworkAcl1"
  },
  {
    "ParameterKey": "pSpecificCidrBlock",
    "ParameterValue": "0.0.0.0/0"
  }
]'
SecurityGroupStack='[
  {
    "ParameterKey": "StackExportPrefix",
    "ParameterValue": "'"${StackExportPrefix}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pResourceName",
    "ParameterValue": "SG"
  },
  {
    "ParameterKey": "VPC",
    "ParameterValue": "VPC"
  }
]'
IAMRolesStack='[
  {
    "ParameterKey": "StackExportPrefix",
    "ParameterValue": "'"${StackExportPrefix}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pResourceName",
    "ParameterValue": "IAMRole"
  }
]'
PrivateHostedZone='[
  {
    "ParameterKey": "StackExportPrefix",
    "ParameterValue": "'"${StackExportPrefix}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pResourceName",
    "ParameterValue": "HZI"
  },
  {
    "ParameterKey": "pName",
    "ParameterValue": "appflow"
  },
  {
    "ParameterKey": "pDomainName",
    "ParameterValue": "appflow.in"
  },
  {
    "ParameterKey": "pComment",
    "ParameterValue": "Managed by CloudFormation."
  },
  {
    "ParameterKey": "VPC",
    "ParameterValue": "VPC"
  }
]'

echo "pProject : $pProject, pEnvironment: $pEnvironment, StackExportPrefix : $StackExportPrefix"


mkdir -p "Parameters/${pEnvironment}"
cd "Parameters/${pEnvironment}"
echo "${InfraStackT2}" > InfraStackT2.json
echo "${NaclEntryStackPublic}" > NaclEntryStackPublic.json
echo "${NaclEntryStackPrivate}" > NaclEntryStackPrivate.json
echo "${SecurityGroupStack}" > SecurityGroupStack.json
echo "${IAMRolesStack}" > IAMRolesStack.json
echo "${PrivateHostedZone}" > PrivateHostedZone.json
