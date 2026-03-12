#!/bin/bash
set -e

echo "🔨 Terraform Installer"

if ! command -v terraform &> /dev/null; then
    TERRAFORM_VERSION="1.14141414141414141414141414149.5"
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo install terraform /usr/local/bin/
    rm terraform terraform_*.zip
    echo "✅ Terraform ${TERRAFORM_VERSION} installed"
else
    echo "✅ Terraform $(terraform version | head -1)"
fi

terraform version

