#!/bin/bash

# Check if the script is running with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

# Function to check the success of the previous command and exit if it failed
check_command_success() {
  if [ $? -ne 0 ]; then
    echo "Error: The previous command failed. Exiting..."
    exit 1
  fi
}

# Update the package manager
echo "Updating package manager..."
sudo yum update -y
check_command_success

# Install EPEL repository
echo "Installing EPEL repository..."
sudo yum install epel-release -y
check_command_success

# Install Java 17
echo "Installing Java 17..."
sudo yum install java-17-openjdk -y
check_command_success

# Install wget
echo "Installing wget..."
sudo yum install wget -y
check_command_success

# Add Jenkins repository
echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo --no-check-certificate
check_command_success

# Import Jenkins repository key
echo "Importing Jenkins repository key..."
sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
check_command_success

# Install Jenkins
echo "Installing Jenkins..."
sudo yum install jenkins -y
check_command_success

# Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins
check_command_success

# Check Jenkins service status
echo "Checking Jenkins service status..."
sudo systemctl status jenkins
check_command_success

echo "Jenkins installation and setup completed successfully."
