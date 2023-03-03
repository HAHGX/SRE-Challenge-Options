#!/bin/bash

# Install Terraform

# Update packages and install dependencies
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add HashiCorp repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update packages and install Terraform
sudo apt-get update && sudo apt-get install terraform
