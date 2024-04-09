
# Define the Default parameters as variables
pProject="project"
pEnvironment="prod"
pResourceName="infra"

# Override Default parameter values by providing new inputs
# Example :: ./templates-parameters.sh -p MyNewProject -e dev -r INFRA

echo "Default :: pProject : $pProject, pEnvironment: $pEnvironment"


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
  esac
done


StackName='[
  {
    "ParameterKey": "pProject",
    "ParameterValue": "'"${pProject}"'"
  },
  {
    "ParameterKey": "pEnvironment",
    "ParameterValue": "'"${pEnvironment}"'"
  }
]'


echo "NEW :: pProject : $pProject, pEnvironment: $pEnvironment"

mkdir -p "Parameters"
echo "$StackName" > Parameters/StackName.json
