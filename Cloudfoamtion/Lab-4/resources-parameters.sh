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


WebLTTGAS='[
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
    "ParameterValue": "WebServer"
  },
  {
    "ParameterKey": "pKeyPair",
    "ParameterValue": "working"
  },
  {
    "ParameterKey": "pTargetPort",
    "ParameterValue": "80"
  },
  {
    "ParameterKey": "VPC",
    "ParameterValue": "VPC"
  },
  {
    "ParameterKey": "Subnets",
    "ParameterValue": "PublicSubnets"
  },
  {
    "ParameterKey": "SGInstance",
    "ParameterValue": "WebServerSG"
  }
]'
App1LTTGAS='[
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
    "ParameterValue": "AppServer1"
  },
  {
    "ParameterKey": "pKeyPair",
    "ParameterValue": "working"
  },
  {
    "ParameterKey": "pTargetPort",
    "ParameterValue": "8080"
  },
  {
    "ParameterKey": "VPC",
    "ParameterValue": "VPC"
  },
  {
    "ParameterKey": "Subnets",
    "ParameterValue": "PublicSubnets"
  },
  {
    "ParameterKey": "SGInstance",
    "ParameterValue": "AppServer1SG"
  }
]'
PublicLoadBalancer='[
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
    "ParameterValue": "LBPublic"
  },
  {
    "ParameterKey": "pLBType",
    "ParameterValue": "application"
  },
  {
    "ParameterKey": "pLBScheme",
    "ParameterValue": "internet-facing"
  },
  {
    "ParameterKey": "pCertificateArn",
    "ParameterValue": "arn:aws:acm:ap-south-1:956976708961:certificate/8cc941f9-584d-4542-b129-d6d0cbd2f5dd"
  },
  {
    "ParameterKey": "VPC",
    "ParameterValue": "VPC"
  },
  {
    "ParameterKey": "Subnets",
    "ParameterValue": "PublicSubnets"
  },
  {
    "ParameterKey": "SGLoadBalancer",
    "ParameterValue": "LBPublicSG"
  }
]'

PrivateLoadBalancer='[
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
    "ParameterValue": "LBPrivate"
  },
  {
    "ParameterKey": "pLBType",
    "ParameterValue": "application"
  },
  {
    "ParameterKey": "pLBScheme",
    "ParameterValue": "internal"
  },
  {
    "ParameterKey": "pCertificateArn",
    "ParameterValue": "arn:aws:acm:ap-south-1:956976708961:certificate/8cc941f9-584d-4542-b129-d6d0cbd2f5dd"
  },
  {
    "ParameterKey": "VPC",
    "ParameterValue": "VPC"
  },
  {
    "ParameterKey": "Subnets",
    "ParameterValue": "PrivateSubnets"
  },
  {
    "ParameterKey": "SGLoadBalancer",
    "ParameterValue": "LBPrivateSG"
  }
]'

HostedZoneRecordSet='[
  {
    "ParameterKey": "StackExportPrefix",
    "ParameterValue": "'"${StackExportPrefix}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  },
  {
    "ParameterKey": "pDomainName",
    "ParameterValue": "appflow.in"
  },
  {
    "ParameterKey": "pPublicHostedZoneId",
    "ParameterValue": "Z0438595YY80OFKPEZGP"
  }
]'

echo "pProject : $pProject, pEnvironment: $pEnvironment, StackExportPrefix : $StackExportPrefix"


mkdir -p "Parameters/${pEnvironment}"
cd "Parameters/${pEnvironment}"

echo "${WebLTTGAS}" > Web-LT-TG-AS.json
echo "${App1LTTGAS}" > App1-LT-TG-AS.json
echo "${PublicLoadBalancer}" > PublicLoadBalancer.json
echo "${PrivateLoadBalancer}" > PrivateLoadBalancer.json
echo "${HostedZoneRecordSet}" > HostedZoneRecordSet.json