# Quantum Advanced Financial System - Credentials

## Default Credentials (Change these in production)

### Application Access
- API Admin User: `admin@quantumfinance.com`
- API Admin Password: `QuantumSecure123!`
- JWT Secret Key: `cXVhbnR1bV9zZWNyZXRfa2V5XzEyMzQ=` (base64 encoded)

### Database
- PostgreSQL User: `quantum_admin`
- PostgreSQL Password: `PgSecure789!`
- Database Name: `quantum_finance`

### Monitoring
- Grafana Admin User: `admin`
- Grafana Admin Password: `password`
- Prometheus Access: No authentication by default (restrict in production)
- Alertmanager SMTP Credentials:
  - SMTP Server: `smtp.example.com:587`
  - SMTP User: `alerts@quantumfinance.com`
  - SMTP Password: `AlertPass123!`

### Kubernetes Secrets
All secrets are base64 encoded in Kubernetes. Decode with:
```bash
echo <encoded_string> | base64 --decode
```

## Credential Management Best Practices
1. Rotate all credentials before production deployment
2. Use Kubernetes Secrets or Vault for production
3. Never commit actual credentials to source control
4. Restrict access using RBAC