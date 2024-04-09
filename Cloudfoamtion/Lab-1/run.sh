# Define the Default parameters as variables
chmod +x parameters.sh

pProject="CICD"
pEnvironment="stage"


# for Override Default parameter values and by providing new inputs for Generate parameter JSON files for templates.
# Example :: ./Parameters.sh -p MyNewProject -e dev -r INFRA

./parameters.sh -p ${pProject} -e ${pEnvironment}