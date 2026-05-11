#!/bin/bash

# AWS EC2 Deployment Script for Monthly Budget Calculator
# Run this script on your AWS EC2 instance (Ubuntu 20.04 or later recommended)

set -e

echo "================================"
echo "Monthly Budget Calculator Setup"
echo "================================"

# Update system packages
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y docker.io docker-compose

# Start Docker service
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group (optional but recommended)
sudo usermod -aG docker $USER

# Create app directory
echo "Creating application directory..."
mkdir -p ~/monthlyexp
cd ~/monthlyexp

# Clone or download your application files
# Replace YOUR_REPO with your actual repository URL
# git clone YOUR_REPO .

# Build Docker image
echo "Building Docker image..."
sudo docker build -t monthlyexp:latest .

# Run Docker container
echo "Running Docker container..."
sudo docker run -d \
  --name monthlyexp-app \
  -p 80:5000 \
  --restart=always \
  monthlyexp:latest

echo "================================"
echo "Deployment Complete!"
echo "================================"
echo ""
echo "Your application is now running on:"
echo "http://YOUR_EC2_PUBLIC_IP"
echo ""
echo "To view logs:"
echo "sudo docker logs -f monthlyexp-app"
echo ""
echo "To stop the container:"
echo "sudo docker stop monthlyexp-app"
