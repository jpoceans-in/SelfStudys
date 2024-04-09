#!/usr/bin/env bash

pProject="project"
pEnvironment="dev"
pResourceName="t2"
pRegion="ap-south-1"


# ./infrastructure-parameters.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
# ./infrastructure-validate.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
# ./infrastructure-create.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
# ./infrastructure-deploy.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
# ./infrastructure-delete.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}



 ./resources-parameters.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
 ./resources-validate.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
 ./resources-create.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}
 # ./resources-delete.sh -p ${pProject} -e ${pEnvironment} -rn ${pResourceName} -r ${pRegion}