#!/bin/bash

BUILD_SCRIPT_FILEPATH="app-deploy.sh"
TERRAGRUNT_FILEPATH="infra/terragrunt.hcl"

help()
{
   echo ""
   echo "Usage: $0 -r AWS_REGION -p AWS_PROFILE"
   echo -e "\t- <AWS_REGION>"
   echo -e "\t-p <AWS_PROFILE>"
   exit 1
}

while getopts "x:z:" opt
do
   case "$opt" in
      x ) AWS_REGION="$OPTARG" ;;
      z ) AWS_PROFILE="$OPTARG" ;;
      ? ) help ;; 
   esac
done

if [ -z "$AWS_REGION" ] || [ -z "$AWS_PROFILE" ]
then
   echo "Some or all of the parameters are empty";
   help
fi

# Validate input
AWS_PROFILE="$(echo ${AWS_PROFILE} | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]_-')"
AWS_REGION="$(echo ${AWS_REGION} | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]_-')"

echo "AWS_REGION=$AWS_REGION"
echo "AWS_PROFILE=$AWS_PROFILE"

set_variables()
{

   export AWS_PROFILE=${AWS_PROFILE}
   export AWS_REGION=${AWS_REGION}
   if [ -f ${BUILD_SCRIPT_FILE_PATH} ] && [ -f ${TERRAGRUNT_FILE_PATH} ]; then
  
      echo "Adding vars to ${BUILD_SCRIPT_FILE_PATH}"
      sed -i -e 's/aws_region/'${AWS_REGION}'/g' ${BUILD_SCRIPT_FILE_PATH}
      sed -i -e 's/aws_profile/'${AWS_PROFILE}'/g' ${BUILD_SCRIPT_FILE_PATH}

      echo "Adding vars to ${TERRAGRUNT_FILE_PATH}"
      sed -i -e 's/aws_region/'${AWS_REGION}'/g' ${TERRAGRUNT_FILE_PATH}
      sed -i -e 's/aws_profile/'${AWS_PROFILE}'/g' ${TERRAGRUNT_FILE_PATH}
    fi
}

set_variables
