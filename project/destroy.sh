#/bin/bash

set -x

rm -rf .terraform
rm -rf terraform.tfstate.backup

echo "Terraform init …"
terraform init -var-file="variables.tfvars" ../tf

echo "Terraform destroy …"
terraform destroy -var-file="variables.tfvars" ../tf

