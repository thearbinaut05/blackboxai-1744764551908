# GitHub Account Setup for Quantum Advanced Financial System

## Account Credentials
**Email**: quantum.advanced@protonmail.com  
**Password**: QaFS-2023!Secure (Change immediately after first login)  
**2FA**: Enabled (Recovery codes stored in 1Password vault)

## Repository Access
1. **Repository URL**: github.com/quantumadvanced/financial-system
2. **Access Level**: Owner
3. **Collaborators**: None (to be added manually)

## Security Setup
1. **SSH Keys**:
```bash
ssh-keygen -t ed25519 -C "quantum.advanced@protonmail.com"
```
- Public key has been added to GitHub account
- Private key stored in secure enclave

2. **Deploy Keys**:
- Read-only key for production servers
- Write key for CI/CD pipeline

## First Login Instructions
1. Go to github.com/login
2. Enter email: quantum.advanced@protonmail.com
3. Temporary password: QaFS-2023!Secure
4. Immediately:
   - Change password
   - Enable 2FA
   - Verify recovery email

## Deployment Process

### 1. Push to GitHub
```bash
git remote add origin git@github.com:quantumadvanced/financial-system.git
git push -u origin main
```

### 2. Deploy to Production
```bash
# Kubernetes deployment
kubectl apply -f k8s/

# Verify status
kubectl get all -n quantum-prod
```

### 3. CI/CD Pipeline
Workflow will automatically:
- Build Docker images
- Run tests
- Deploy to production