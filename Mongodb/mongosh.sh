#!/bin/bash

# MongoDB 7.0 Installation Script

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y
check_error "Failed to update packages"

# Install gnupg and curl if not already installed
echo "Installing gnupg and curl..."
sudo apt-get install -y gnupg curl
check_error "Failed to install gnupg and curl"

# Add MongoDB GPG key
echo "Adding MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
check_error "Failed to add MongoDB GPG key"

# Add MongoDB repository
echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
check_error "Failed to add MongoDB repository"

# Update package list again
echo "Updating package list..."
sudo apt-get update -y
check_error "Failed to update package list"

# Install MongoDB packages
echo "Installing MongoDB packages..."
sudo apt-get install -y mongodb-org=7.0.14 mongodb-org-database=7.0.14 mongodb-org-server=7.0.14 mongodb-mongosh mongodb-org-mongos=7.0.14 mongodb-org-tools=7.0.14
check_error "Failed to install MongoDB packages"

# Start MongoDB service
echo "Starting MongoDB service..."
sudo systemctl start mongod
check_error "Failed to start MongoDB service"

# Enable MongoDB service to start on boot
echo "Enabling MongoDB service to start on boot..."
sudo systemctl enable mongod
check_error "Failed to enable MongoDB service"

echo "MongoDB 7.0 installation completed successfully."
