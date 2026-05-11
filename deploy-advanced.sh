#!/bin/bash

# AWS EC2 Advanced Deployment Script with CloudWatch Logs
# This script sets up the application with logging and monitoring

set -e

echo "Starting Monthly Budget Calculator deployment..."

# Variables
APP_NAME="monthlyexp"
APP_HOME="/home/ec2-user/$APP_NAME"

# Create app directory
sudo mkdir -p $APP_HOME
sudo chown -R ec2-user:ec2-user $APP_HOME

# Navigate to app directory
cd $APP_HOME

# Install Docker and Docker Compose
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create systemd service for Docker container
echo "Creating systemd service..."
sudo tee /etc/systemd/system/monthlyexp.service > /dev/null <<EOF
[Unit]
Description=Monthly Budget Calculator
After=docker.service
Requires=docker.service

[Service]
Type=simple
Restart=always
RestartSec=10
User=root
ExecStart=/usr/bin/docker run --rm --name monthlyexp-app -p 80:5000 --log-driver awslogs --log-opt awslogs-group=/aws/ec2/monthlyexp --log-opt awslogs-region=\$(ec2-metadata --availability-zone | cut -d' ' -f2) monthlyexp:latest
ExecStop=/usr/bin/docker stop monthlyexp-app

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

echo "Deployment script completed successfully!"
