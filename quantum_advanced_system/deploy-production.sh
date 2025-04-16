#!/bin/bash
# Quantum Advanced Finance System - Complete Production Deployment

# Configuration
DOMAIN="quantumadvancedfinance.com"
EMAIL="admin@$DOMAIN"
DEPLOY_DIR="/var/www/$DOMAIN"
BACKUP_DIR="/var/backups/$DOMAIN"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Validate sudo access
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Create backup
echo "Creating backup..."
mkdir -p $BACKUP_DIR
tar -czf "$BACKUP_DIR/backup-$TIMESTAMP.tar.gz" $DEPLOY_DIR 2>/dev/null || true

# Install dependencies
echo "Installing dependencies..."
apt-get update
apt-get install -y nginx certbot python3-certbot-nginx nodejs npm docker.io

# Clone repository
echo "Setting up application..."
mkdir -p $DEPLOY_DIR
git clone https://github.com/quantumadvanced/financial-system.git $DEPLOY_DIR
cd $DEPLOY_DIR

# Build Docker images
echo "Building Docker containers..."
docker-compose build

# Set up Kubernetes
echo "Initializing Kubernetes cluster..."
kubectl apply -f k8s/

# Configure web server
echo "Configuring Nginx..."
cat > /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root $DEPLOY_DIR/web;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /api {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /ws {
        proxy_pass http://localhost:8000/ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
    }
}
EOF

ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# Set up SSL
echo "Configuring SSL..."
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m $EMAIL

# Configure firewall
echo "Configuring firewall..."
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
ufw enable

# Initialize database
echo "Initializing database..."
kubectl exec -it $(kubectl get pods -n quantum-prod | grep postgres | awk '{print $1}') -n quantum-prod -- psql -U quantum_admin -d quantum_finance -f /docker-entrypoint-initdb.d/init.sql

# Start services
echo "Starting services..."
docker-compose up -d
kubectl scale deployment quantum-app --replicas=3 -n quantum-prod

# Verify deployment
echo "Verifying deployment..."
kubectl get all -n quantum-prod
docker ps
curl -I https://$DOMAIN

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  Quantum Advanced Finance System Deployed ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Dashboard URL: https://$DOMAIN"
echo "API Endpoint: https://api.$DOMAIN/v1"
echo "Grafana: https://monitor.$DOMAIN"
echo ""
echo "Initial credentials available in CREDENTIALS.md"