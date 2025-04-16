# Quantum Advanced Financial System - Deployment Guide

## 1. Initial Setup
```bash
# Clone repository
git clone git@github.com:quantumadvanced/financial-system.git
cd financial-system

# Set up environment
cp .env.example .env
nano .env  # Configure environment variables
```

## 2. Kubernetes Deployment
```bash
# Create namespace
kubectl create namespace quantum-prod

# Apply configurations
kubectl apply -f k8s/ -n quantum-prod

# Verify deployment
kubectl get all -n quantum-prod
```

## 3. First-Time Access
1. Grafana: http://[YOUR_IP]:3000
   - User: admin
   - Password: (from CREDENTIALS.md)

2. API Endpoint: http://[YOUR_IP]:8000
   - JWT Secret: (from CREDENTIALS.md)

## 4. Maintenance
```bash
# View logs
kubectl logs -l app=quantum-app -n quantum-prod

# Scale services
kubectl scale deployment quantum-app --replicas=5 -n quantum-prod
```

## 5. Backup Procedures
```bash
# Database backup
kubectl exec -n quantum-prod [POSTGRES_POD] -- pg_dump -U quantum_admin quantum_finance > backup.sql

# Configuration backup
kubectl get all -n quantum-prod -o yaml > cluster_backup.yaml