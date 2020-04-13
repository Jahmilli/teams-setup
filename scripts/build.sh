#!/bin/bash

cd terraform/backend/

# -z Check for empty
# -n Check for not empty
if [[ -z "${ENVIRONMENT}" ]]; then
    echo "Environment is empty: ${ENVIRONMENT}"
    exit 1
fi

echo "Beginning terraform init"
terraform init

# If workspace doesn't exist, run: terraform workspace new $ENVIRONMENT
terraform workspace select ${ENVIRONMENT}
CODE=`echo $?`

if [[ "${CODE}" == "1" ]]; then
    echo "Creating new workspace ${ENVIRONMENT}"
    terraform workspace new ${ENVIRONMENT} && terraform workspace select ${ENVIRONMENT}
fi


echo "Running terraform ${TERRAFORM_RUN}"
if [[ "${TERRAFORM_RUN}" == "apply" ]]; then
    terraform apply -auto-approve
elif [[ "${TERRAFORM_RUN}" == "destroy"  ]]; then
    terraform destroy -auto-approve
else
    terraform plan
fi

# Move back to root dir
cd ../../
