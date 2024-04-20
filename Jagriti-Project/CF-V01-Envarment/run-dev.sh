#!/usr/bin/env bash

pProject="project"
pEnvironment="dev"
pResourceName="t2"
pRegion="us-east-1"


./infrastructure-validate.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
./infrastructure-create.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
#./infrastructure-deploy.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
#./infrastructure-delete.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
