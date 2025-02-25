#!/bin/bash

# Ensure the script runs in non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Update the package lists and install necessary tools
sudo apt-get update -y
sudo apt-get install -y docker.io unzip curl

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/home/ubuntu/awscliv2.zip"
unzip -o /home/ubuntu/awscliv2.zip -d /home/ubuntu/
sudo /home/ubuntu/aws/install

# Add 'ubuntu' user to the 'docker' group (run Docker without 'sudo')
sudo usermod -aG docker ubuntu

# Clean up installation files
rm -rf /home/ubuntu/awscliv2.zip /home/ubuntu/aws
