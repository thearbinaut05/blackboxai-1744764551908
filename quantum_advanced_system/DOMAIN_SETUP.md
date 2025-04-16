# Quantum Advanced Financial System - Domain Setup

## Registered Domain
- **Primary Domain**: quantumadvancedfinance.com
- **Alternative Domains**: 
  - qafs.io (for API endpoints)
  - quantum-fintech.ai (for marketing)

## DNS Configuration
```bash
# DNS Records
A @ → [YOUR_SERVER_IP]
CNAME api → qafs.io
CNAME app → quantumadvancedfinance.com
MX @ → mail.quantumadvancedfinance.com
TXT @ → "v=spf1 include:_spf.quantumadvancedfinance.com ~all"
```

## SSL Certificates
```bash
# Generate Let's Encrypt Certificates
certbot certonly --manual \
  -d quantumadvancedfinance.com \
  -d *.quantumadvancedfinance.com \
  --preferred-challenges dns
```

## Email Setup
- **Business Email**: contact@quantumadvancedfinance.com
- **Admin Email**: admin@quantumadvancedfinance.com
- **Security**: ProtonMail Bridge configured