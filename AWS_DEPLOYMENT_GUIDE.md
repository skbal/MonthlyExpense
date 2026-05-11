# AWS EC2 Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the Monthly Budget Calculator on AWS EC2.

## Prerequisites
- AWS Account with EC2 access
- Basic knowledge of AWS Console
- SSH client installed on your local machine
- Git installed (for cloning the repository)

## Option 1: Quick Launch with User Data (Recommended for Beginners)

### Step 1: Launch EC2 Instance
1. Go to [AWS EC2 Dashboard](https://console.aws.amazon.com/ec2/)
2. Click **Launch Instances**
3. Choose AMI: **Amazon Linux 2 AMI** (free tier eligible)
4. Instance Type: **t2.micro** (free tier)
5. Click **Next: Configure Instance Details**

### Step 2: Configure Instance
1. Number of instances: `1`
2. Network: Use default VPC
3. Subnet: Use default
4. Auto-assign Public IP: **Enable**
5. Click **Next: Add Storage**

### Step 3: Add Storage
- Use default (8 GB)
- Click **Next: Add Tags**

### Step 4: Add Tags (Optional)
- Key: `Name`, Value: `monthlyexp-app`
- Click **Next: Configure Security Group**

### Step 5: Configure Security Group
1. Create new security group: `monthlyexp-sg`
2. Add rules:
   - Type: **HTTP**, Source: **0.0.0.0/0**
   - Type: **HTTPS**, Source: **0.0.0.0/0**
   - Type: **SSH**, Source: **0.0.0.0/0** (restrict this to your IP)
3. Click **Review and Launch**

### Step 6: Add User Data Script
1. Click **Edit details** in bottom area
2. Expand **Advanced details**
3. Paste contents of `user-data.sh` into **User Data** field
4. Click **Review and Launch**

### Step 7: Review and Launch
1. Review all settings
2. Click **Launch**
3. Create new key pair:
   - Name: `monthlyexp-key`
   - Click **Download Key Pair**
4. Click **Launch Instances**

### Step 8: Access Your Application
1. Wait 2-3 minutes for instance to start
2. In EC2 Dashboard, copy **Public IPv4** address
3. Open browser: `http://<YOUR_PUBLIC_IP>`

## Option 2: Manual Deployment

### Step 1: Launch EC2 Instance (same as above)

### Step 2: Connect via SSH
```bash
# Change permissions on key file
chmod 400 monthlyexp-key.pem

# Connect to instance
ssh -i monthlyexp-key.pem ec2-user@<YOUR_PUBLIC_IP>
```

### Step 3: Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/monthlyexp.git
cd monthlyexp
```

### Step 4: Run Deployment Script
```bash
chmod +x deploy.sh
./deploy.sh
```

### Step 5: Access Application
Open browser: `http://<YOUR_PUBLIC_IP>`

## Option 3: Using Docker Compose (Production Ready)

### Step 1-2: Same as Manual Deployment

### Step 3: Build and Run with Docker Compose
```bash
docker-compose -f docker-compose-prod.yml up -d
```

### Step 4: Verify Deployment
```bash
docker-compose -f docker-compose-prod.yml ps
```

## Accessing Your Application

### Via Public IP (Temporary)
```
http://<YOUR_PUBLIC_IP>
```

### Via Elastic IP (Persistent)
1. In EC2 Dashboard, click **Elastic IPs**
2. **Allocate new address**
3. Select your instance
4. Associate the IP
5. Use: `http://<ELASTIC_IP>`

### Via Domain Name (Recommended)
1. Purchase domain (Route 53, GoDaddy, etc.)
2. Create DNS A record pointing to Elastic IP
3. Use: `http://your-domain.com`

## Setting Up HTTPS (SSL/TLS)

### Using Let's Encrypt (Free)
```bash
# Connect to instance
ssh -i monthlyexp-key.pem ec2-user@<YOUR_PUBLIC_IP>

# Install certbot
sudo yum install -y certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --standalone -d your-domain.com

# Update nginx.conf with SSL configuration (uncomment the HTTPS section)
# Restart nginx
docker restart monthlyexp-nginx
```

### Using AWS Certificate Manager (Recommended)
1. Request certificate in ACM console
2. Set up CloudFront distribution
3. Configure load balancer with SSL

## Monitoring and Management

### View Logs
```bash
# Application logs
docker logs -f monthlyexp-app

# Nginx logs
docker logs -f monthlyexp-nginx

# System logs
tail -f /var/log/user-data.log
```

### Check Application Status
```bash
docker ps
```

### Restart Application
```bash
docker restart monthlyexp-app
```

### Stop Application
```bash
docker stop monthlyexp-app
docker-compose -f docker-compose-prod.yml down
```

## AWS Monitoring Integration

### CloudWatch Dashboard
1. Go to CloudWatch console
2. Create new dashboard
3. Add metrics:
   - EC2 CPU Utilization
   - EC2 Network In/Out
   - Custom application metrics

### CloudWatch Alarms
```bash
# Setup alarm for high CPU usage
- Threshold: 80%
- Action: SNS notification or auto-scaling
```

## Cost Optimization

### Free Tier Usage
- **t2.micro**: 750 hours/month (free)
- **EBS**: 30 GB/month (free)
- **Data transfer**: 1 GB/month (free)

### Reduce Costs
- Use Reserved Instances for long-term deployment
- Set up Auto Scaling for peak times
- Use S3 for static file serving
- Enable CloudFront CDN for caching

## Backup and Recovery

### Create AMI (Machine Image)
```bash
1. Right-click instance in EC2 Dashboard
2. Select "Image and templates" > "Create image"
3. Name: monthlyexp-backup-<date>
4. Create image
```

### Restore from AMI
```bash
1. Go to AMIs in EC2 Dashboard
2. Select your backup image
3. Click "Launch"
```

## Scaling Your Application

### Load Balancer Setup
```bash
1. Create Application Load Balancer
2. Configure target group with your instance
3. Attach to EC2 instance
4. Access via load balancer DNS
```

### Auto Scaling
```bash
1. Create launch template from current instance
2. Create Auto Scaling group
3. Set desired capacity and scaling policies
4. CloudFront for CDN distribution
```

## Security Best Practices

✅ **Implemented**
- Security groups restrict traffic
- Docker container isolation
- Regular security updates

⚠️ **Recommended**
- Enable VPC Flow Logs
- Use AWS Systems Manager for patching
- Enable CloudTrail for audit logs
- Implement WAF (Web Application Firewall)
- Use Secrets Manager for credentials
- Enable S3 versioning for backups

### Security Checklist
- [ ] SSH key stored securely
- [ ] Security group rules reviewed
- [ ] No default credentials used
- [ ] SSL/HTTPS enabled
- [ ] Regular backups created
- [ ] CloudWatch monitoring enabled
- [ ] Firewall rules configured

## Troubleshooting

### Application Not Accessible
```bash
# Check instance status
aws ec2 describe-instance-status --instance-ids <INSTANCE_ID>

# Check security group
aws ec2 describe-security-groups --group-ids <GROUP_ID>

# Test connection
telnet <PUBLIC_IP> 80
```

### Docker Container Issues
```bash
# Restart container
docker restart monthlyexp-app

# Check logs
docker logs --tail=100 monthlyexp-app

# Rebuild image
docker build --no-cache -t monthlyexp:latest .
```

### Port Already in Use
```bash
# Find process using port 80
sudo lsof -i :80

# Kill process
sudo kill -9 <PID>

# Or change port in Dockerfile and nginx.conf
```

## Advanced: CI/CD Pipeline

### GitHub Actions Deployment
```yaml
name: Deploy to AWS EC2
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to EC2
        env:
          SSH_KEY: ${{ secrets.SSH_KEY }}
        run: |
          eval $(ssh-agent -s)
          ssh-add - <<< "$SSH_KEY"
          ssh -o StrictHostKeyChecking=no ec2-user@${{ secrets.EC2_HOST }} './deploy.sh'
```

## Support and Resources

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Docker Documentation](https://docs.docker.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Project GitHub Repository](https://github.com/YOUR_USERNAME/monthlyexp)

## Next Steps

1. ✅ Deploy application
2. ✅ Configure domain name
3. ✅ Set up HTTPS/SSL
4. ✅ Configure monitoring and alerts
5. ✅ Set up automated backups
6. ✅ Implement CI/CD pipeline
7. ✅ Scale to multiple instances
