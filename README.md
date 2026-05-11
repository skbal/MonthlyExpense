# Monthly Budget Calculator - Web Application

A modern, responsive web application for calculating and tracking monthly budgets. Deploy it on AWS EC2 for access from anywhere!

## Features

✨ **Modern UI** - Clean, gradient-based responsive design
💰 **Budget Tracking** - Track income and expenses across multiple categories
📊 **Savings Rate** - Automatic savings rate calculation
📱 **Responsive** - Works on desktop, tablet, and mobile devices
🚀 **Production Ready** - Docker containerized for easy deployment

## Project Structure

```
MonthlyExp/
├── app.py                 # Flask application
├── requirements.txt       # Python dependencies
├── Dockerfile            # Docker image configuration
├── docker-compose.yml    # Docker Compose setup
├── deploy.sh            # Basic deployment script
├── deploy-advanced.sh   # Advanced deployment with CloudWatch
├── templates/
│   └── index.html       # Web interface
└── README.md            # This file
```

## Local Development

### Prerequisites
- Python 3.8+
- pip or conda
- Docker (optional, for containerized development)

### Setup

1. **Clone/Download the project**
```bash
cd c:\Extra\Study\GIT\MonthlyExp
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Run the application**
```bash
python app.py
```

5. **Access the application**
Open your browser and go to `http://localhost:5000`

### Using Docker (Local)

```bash
# Build the image
docker build -t monthlyexp:latest .

# Run the container
docker run -p 5000:5000 monthlyexp:latest

# OR using docker-compose
docker-compose up
```

## AWS EC2 Deployment

### Prerequisites
- AWS EC2 instance running Ubuntu 20.04 or Amazon Linux 2
- SSH access to your instance
- Public IP or Elastic IP assigned

### Step 1: Connect to Your EC2 Instance

```bash
ssh -i /path/to/your/key.pem ec2-user@your-ec2-public-ip
```

### Step 2: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/monthlyexp.git
cd monthlyexp
```

### Step 3: Run Deployment Script

**Option A: Basic Setup**
```bash
chmod +x deploy.sh
./deploy.sh
```

**Option B: Advanced Setup (with CloudWatch)**
```bash
chmod +x deploy-advanced.sh
sudo ./deploy-advanced.sh
```

### Step 4: Access Your Application

Once deployment is complete, access your application at:
```
http://YOUR_EC2_PUBLIC_IP
```

## Docker Deployment Details

### Building the Image
```bash
docker build -t monthlyexp:latest .
```

### Running the Container

**Development Mode**
```bash
docker run -it -p 5000:5000 monthlyexp:latest
```

**Production Mode**
```bash
docker run -d \
  --name monthlyexp-app \
  -p 80:5000 \
  --restart=always \
  monthlyexp:latest
```

### Container Management

```bash
# View running containers
docker ps

# View logs
docker logs monthlyexp-app

# Stop container
docker stop monthlyexp-app

# Restart container
docker restart monthlyexp-app

# Remove container
docker rm monthlyexp-app
```

## Environment Variables

Create a `.env` file for configuration (optional):

```env
FLASK_ENV=production
FLASK_DEBUG=0
WORKERS=4
TIMEOUT=120
```

## Security Best Practices

1. **Security Groups**: Configure AWS Security Group to allow:
   - Inbound: HTTP (80), HTTPS (443) from 0.0.0.0/0
   - Outbound: All traffic

2. **SSL/HTTPS**: Set up with AWS Certificate Manager or Let's Encrypt
   ```bash
   sudo apt-get install certbot python3-certbot-nginx
   sudo certbot certonly --standalone -d your-domain.com
   ```

3. **Firewall**: Enable UFW on EC2
   ```bash
   sudo ufw allow 22/tcp
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw enable
   ```

4. **Regular Updates**: Keep your EC2 instance updated
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

## Monitoring and Logs

### View Application Logs
```bash
docker logs -f monthlyexp-app
```

### CloudWatch Integration (Advanced Setup)
The advanced deployment script integrates with AWS CloudWatch for centralized logging.

View logs in CloudWatch Console:
- Navigate to CloudWatch > Logs
- Look for `/aws/ec2/monthlyexp` log group

## Troubleshooting

### Application won't start
```bash
# Check if port 5000/80 is already in use
sudo lsof -i :5000
sudo lsof -i :80

# Kill process using the port
sudo kill -9 <PID>
```

### Can't connect to application
- Verify EC2 Security Group allows HTTP traffic
- Check if Docker container is running: `docker ps`
- View logs: `docker logs monthlyexp-app`

### Docker image build fails
```bash
# Clear cache and rebuild
docker system prune -a
docker build --no-cache -t monthlyexp:latest .
```

## Performance Optimization

The application uses:
- **Gunicorn**: WSGI HTTP Server with multiple workers
- **4 Workers**: Default for balanced performance
- **120s Timeout**: For long-running requests

Adjust in `Dockerfile` if needed:
```dockerfile
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "8", "--timeout", "180", "app:app"]
```

## Scaling on AWS

### Option 1: EC2 Auto Scaling
1. Create an AMI from your configured EC2 instance
2. Create a Launch Template
3. Set up Auto Scaling Group with desired capacity

### Option 2: AWS ECS (Recommended)
1. Push image to Amazon ECR
2. Create ECS task definition
3. Launch ECS service with load balancing

### Option 3: AWS App Runner
Simple serverless container deployment with automatic scaling

## Contributing

Pull requests are welcome! For major changes, please open an issue first.

## License

This project is open source and available under the MIT License.

## Support

For issues and questions:
- Create an issue on GitHub
- Check AWS documentation: https://docs.aws.amazon.com
- Docker documentation: https://docs.docker.com

## Deployment Checklist

- [ ] EC2 instance created and running
- [ ] Security groups configured
- [ ] Application deployed and running
- [ ] Application accessible from browser
- [ ] Logs being generated properly
- [ ] Monitoring set up (optional)
- [ ] Backups configured (optional)
- [ ] Domain name configured (optional)
- [ ] SSL certificate installed (optional)
