#!/bin/bash
# AWS EC2 User Data Script
# Paste this in EC2 Instance Launch > Advanced Details > User Data
# It will automatically set up your Monthly Budget Calculator on instance launch

set -e

# Log setup
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting Monthly Budget Calculator deployment at $(date)"

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y

# Start Docker
systemctl start docker
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Create app directory
mkdir -p /home/ec2-user/monthlyexp
cd /home/ec2-user/monthlyexp

# Clone repository (replace with your repo)
# git clone https://github.com/YOUR_USERNAME/monthlyexp.git .

# If files aren't cloned, create them manually
# For now, we'll assume they're already present

# Build and run Docker container
docker build -t monthlyexp:latest .
docker run -d \
  --name monthlyexp-app \
  -p 80:5000 \
  --restart=always \
  monthlyexp:latest

echo "Monthly Budget Calculator deployment completed at $(date)"
echo "Application should be accessible at http://$(ec2-metadata --public-ipv4 | cut -d' ' -f2)"
