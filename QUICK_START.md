# Quick Start Guide

## 5-Minute Local Setup

### 1. Install Dependencies
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Run Application
```bash
python app.py
```

### 3. Open in Browser
```
http://localhost:5000
```

## 15-Minute Docker Setup

### 1. Build Image
```bash
docker build -t monthlyexp:latest .
```

### 2. Run Container
```bash
docker run -p 5000:5000 monthlyexp:latest
```

### 3. Open in Browser
```
http://localhost:5000
```

## AWS EC2 Deployment (30 Minutes)

### Option A: Automated (Recommended)
1. Launch EC2 instance
2. Copy `user-data.sh` content to User Data
3. Wait 3 minutes
4. Visit `http://<PUBLIC_IP>`

### Option B: Manual
1. SSH into EC2: `ssh -i key.pem ec2-user@<PUBLIC_IP>`
2. Clone repo: `git clone <REPO_URL>`
3. Run: `chmod +x deploy.sh && ./deploy.sh`
4. Visit `http://<PUBLIC_IP>`

## File Structure

```
monthlyexp/
├── app.py                    # Flask backend
├── requirements.txt          # Dependencies
├── Dockerfile               # Container definition
├── docker-compose.yml       # Local docker setup
├── docker-compose-prod.yml  # Production setup with nginx
├── nginx.conf              # Nginx reverse proxy config
├── deploy.sh               # Basic deployment script
├── deploy-advanced.sh      # Advanced deployment with CloudWatch
├── user-data.sh           # AWS EC2 auto-deployment script
├── templates/
│   └── index.html         # Web UI
├── .env.example           # Environment variables template
├── .gitignore            # Git ignore rules
├── README.md             # Full documentation
├── AWS_DEPLOYMENT_GUIDE.md # AWS-specific guide
└── QUICK_START.md        # This file
```

## Key Commands

### Local Development
```bash
# Start development server
python app.py

# Run with Docker
docker run -p 5000:5000 monthlyexp:latest

# Run with Docker Compose
docker-compose up
```

### Docker Management
```bash
# Build image
docker build -t monthlyexp:latest .

# View running containers
docker ps

# View logs
docker logs -f monthlyexp-app

# Stop container
docker stop monthlyexp-app
```

### EC2 SSH Commands
```bash
# Connect to instance
ssh -i monthlyexp-key.pem ec2-user@<PUBLIC_IP>

# View application logs
docker logs -f monthlyexp-app

# Restart application
docker restart monthlyexp-app

# Stop and remove container
docker stop monthlyexp-app
docker rm monthlyexp-app
```

## Deployment Checklist

### Before Deployment
- [ ] Git repository created
- [ ] Dependencies in requirements.txt
- [ ] Dockerfile tested locally
- [ ] Application tested with `python app.py`

### AWS EC2 Setup
- [ ] AWS account active
- [ ] EC2 security group created
- [ ] Key pair downloaded and saved
- [ ] Public IP or Elastic IP assigned

### Post-Deployment
- [ ] Application accessible on public IP
- [ ] Docker logs show no errors
- [ ] Application responds to requests
- [ ] Consider setting up domain name
- [ ] Consider enabling HTTPS/SSL

## Environment Variables

Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

Edit with your settings:
```env
FLASK_ENV=production
WORKERS=4
```

## Testing

### Local Test
```bash
# Start application
python app.py

# In another terminal
curl http://localhost:5000

# Open browser
open http://localhost:5000
```

### Docker Test
```bash
# Build and run
docker build -t monthlyexp:latest .
docker run -p 5000:5000 monthlyexp:latest

# Test endpoint
curl http://localhost:5000
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 5000 already in use | `sudo lsof -i :5000` and kill process, or change port in app.py |
| Docker won't build | `docker system prune -a` and rebuild |
| Can't connect to EC2 | Check security group allows SSH (port 22) |
| Application not responding | Check logs: `docker logs monthlyexp-app` |
| High CPU usage | Reduce worker count in Dockerfile or increase instance type |

## Next Steps

1. **Test Locally** - Run with `python app.py`
2. **Test with Docker** - Run with `docker-compose up`
3. **Deploy to EC2** - Follow AWS_DEPLOYMENT_GUIDE.md
4. **Set Up Domain** - Configure Route 53 or external DNS
5. **Enable HTTPS** - Use Let's Encrypt or AWS Certificate Manager
6. **Set Up Monitoring** - CloudWatch dashboard and alarms
7. **Auto Scaling** - Configure load balancer and auto-scaling

## Resources

- **Documentation**: See README.md for detailed info
- **AWS Guide**: See AWS_DEPLOYMENT_GUIDE.md
- **Code**: Flask in app.py, HTML in templates/index.html
- **Docker**: Dockerfile for containerization
- **Deployment**: deploy.sh for quick setup

## Support

For issues, check:
1. Docker logs: `docker logs monthlyexp-app`
2. System logs: `/var/log/user-data.log` on EC2
3. README.md troubleshooting section
4. AWS_DEPLOYMENT_GUIDE.md

---

**Happy Deploying!** 🚀
