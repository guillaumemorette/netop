#/bin/bash

set -x

rm -rf .terraform
rm -rf terraform.tfstate.backup

echo "Terraform init …"
terraform init -var-file="variables.tfvars" ../tf

echo "Terraform apply  …"
terraform apply -var-file="variables.tfvars" ../tf

