# Production Secrets & Configuration

## 🔐 Generated JWT Secret

```
797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
```

**Generated**: 2026-05-20
**Strength**: 256-bit (32 bytes) - Cryptographically secure

## 📋 Production Environment Variables

### Backend (.env.production)

```env
# Database Configuration
DATABASE_URL="postgresql://user:password@host:5432/task_manager"

# JWT Secret (Generated)
JWT_SECRET="797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137"

# Environment
NODE_ENV="production"
PORT=5000

# Optional: Logging Level
LOG_LEVEL="info"

# Optional: Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Optional: CORS
CORS_ORIGIN="https://your-frontend-domain.com"

# Optional: Database SSL
DATABASE_SSL="true"
```

### Frontend (.env.production)

```env
# API Configuration
VITE_API_URL="https://your-backend-domain.com/api/v1"

# Optional: Analytics
# VITE_ANALYTICS_ID="your-analytics-id"

# Optional: Sentry Error Tracking
# VITE_SENTRY_DSN="your-sentry-dsn"
```

## 🚀 Deployment Platform Setup

### Render Setup

1. **Backend Service Environment Variables**:
   ```
   DATABASE_URL=postgresql://taskuser:password@host:5432/task_manager
   JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
   NODE_ENV=production
   PORT=5000
   ```

2. **Frontend Service Environment Variables**:
   ```
   VITE_API_URL=https://task-manager-api.onrender.com/api/v1
   ```

### Railway Setup

1. **Backend Service Variables**:
   ```
   NODE_ENV=production
   JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
   PORT=5000
   ```
   (DATABASE_URL auto-generated from PostgreSQL)

2. **Frontend Service Variables**:
   ```
   VITE_API_URL=https://your-backend-url/api/v1
   ```

### Heroku Setup

```bash
# Backend
heroku config:set JWT_SECRET="797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137" -a task-manager-api
heroku config:set NODE_ENV="production" -a task-manager-api

# Frontend
heroku config:set VITE_API_URL="https://task-manager-api.herokuapp.com/api/v1" -a task-manager-ui
```

### AWS Setup

1. **Create Systems Manager Parameter Store entries**:
   ```
   /task-manager/prod/jwt-secret = 797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
   /task-manager/prod/database-url = postgresql://...
   /task-manager/prod/node-env = production
   ```

2. **Or use AWS Secrets Manager**:
   ```bash
   aws secretsmanager create-secret \
     --name task-manager/prod/jwt-secret \
     --secret-string "797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137"
   ```

## 🔒 Security Best Practices

### JWT Secret Security

✅ **DO**:
- Use cryptographically secure random generation
- Store in environment variables (never in code)
- Rotate periodically (every 6-12 months)
- Use different secrets for different environments
- Keep secret length at least 32 bytes (256 bits)
- Use strong random generation: `crypto.randomBytes(32)`

❌ **DON'T**:
- Commit secrets to version control
- Use weak or predictable secrets
- Share secrets via email or chat
- Use same secret across environments
- Log or expose secrets
- Use secrets shorter than 32 bytes

### Database Password Security

Generate strong database password:
```bash
node -e "console.log(require('crypto').randomBytes(16).toString('hex'))"
```

Example: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`

### Environment Variable Security

**Render**:
- Secrets are encrypted at rest
- Only visible to authorized team members
- Automatically redacted in logs

**Railway**:
- Secrets are encrypted
- Can be marked as "sensitive"
- Not shown in logs

**Heroku**:
- Config vars are encrypted
- Use `heroku config:set` for secrets
- Never use `git push` with secrets

**AWS**:
- Use AWS Secrets Manager
- Use AWS Systems Manager Parameter Store
- Enable encryption at rest
- Enable audit logging

## 📝 Secrets Rotation

### When to Rotate

- Every 6-12 months (regular rotation)
- Immediately if compromised
- When team member leaves
- After security incident
- Before major deployment

### How to Rotate JWT Secret

1. Generate new secret:
   ```bash
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```

2. Update in platform:
   - Render: Update environment variable
   - Railway: Update variable
   - Heroku: `heroku config:set JWT_SECRET="new-secret"`
   - AWS: Update in Secrets Manager

3. Redeploy application:
   - Service automatically redeploys
   - New secret takes effect

4. Old tokens become invalid:
   - Users need to login again
   - This is expected behavior

## 🔐 Secrets Management Tools

### Option 1: Platform Native (Recommended)
- Render: Built-in environment variables
- Railway: Built-in variables
- Heroku: Config vars
- AWS: Secrets Manager

### Option 2: Third-Party Tools

**HashiCorp Vault**:
```bash
vault kv put secret/task-manager/prod \
  jwt_secret="797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137"
```

**1Password**:
- Store secrets in 1Password
- Use 1Password CLI to inject at deploy time

**AWS Secrets Manager**:
```bash
aws secretsmanager create-secret \
  --name task-manager/prod/secrets \
  --secret-string '{
    "jwt_secret": "797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137",
    "database_url": "postgresql://..."
  }'
```

## 📊 Secrets Checklist

Before Deployment:
- ☐ JWT_SECRET generated (32+ bytes)
- ☐ DATABASE_URL configured
- ☐ NODE_ENV set to "production"
- ☐ CORS_ORIGIN configured
- ☐ All secrets in environment variables
- ☐ No secrets in code
- ☐ No secrets in git history
- ☐ Secrets encrypted at rest
- ☐ Secrets access logged
- ☐ Team trained on secrets management

## 🚨 If Secret is Compromised

1. **Immediately**:
   - Generate new secret
   - Update in all environments
   - Redeploy application

2. **Within 24 hours**:
   - Review access logs
   - Check for unauthorized access
   - Audit database changes

3. **Within 1 week**:
   - Rotate all other secrets
   - Update security policies
   - Document incident

## 📞 Support

- **Render Secrets**: https://render.com/docs/environment-variables
- **Railway Secrets**: https://docs.railway.app/develop/variables
- **Heroku Config**: https://devcenter.heroku.com/articles/config-vars
- **AWS Secrets Manager**: https://aws.amazon.com/secrets-manager/

---

## ✅ Your Production Secrets

**JWT Secret**: `797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137`

**Status**: ✅ Generated and ready to use

**Next**: Add to your deployment platform environment variables

---

**Keep your secrets safe! 🔐**
