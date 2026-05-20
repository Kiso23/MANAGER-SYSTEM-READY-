# Environment Variables Guide

Complete reference for all environment variables needed for production deployment.

## 📋 Quick Summary

### Backend Environment Variables (Required)
```env
DATABASE_URL=postgresql://user:password@host:5432/task_manager
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
NODE_ENV=production
PORT=5000
```

### Frontend Environment Variables (Required)
```env
VITE_API_URL=https://your-backend-url/api/v1
```

---

## 🔧 Backend Environment Variables

### Required Variables

#### 1. DATABASE_URL
**Purpose**: PostgreSQL database connection string
**Format**: `postgresql://username:password@host:port/database`
**Example**: `postgresql://taskuser:mypassword@db.example.com:5432/task_manager`
**Where to get**:
- Render: Info tab of PostgreSQL service
- Railway: Variables tab (auto-generated)
- Heroku: `heroku config:get DATABASE_URL`
- AWS RDS: Build from endpoint, port, username, password

#### 2. JWT_SECRET
**Purpose**: Secret key for JWT token signing
**Format**: 32+ character random string
**Example**: `797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137`
**Generate**: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
**Security**: Keep this secret! Never commit to git.

#### 3. NODE_ENV
**Purpose**: Specifies environment (development/production)
**Value**: `production`
**Why**: Enables production optimizations and security features

#### 4. PORT
**Purpose**: Port number for backend server
**Value**: `5000`
**Note**: Most platforms auto-assign, but set this for consistency

### Optional Variables

#### 5. LOG_LEVEL
**Purpose**: Logging verbosity
**Values**: `error`, `warn`, `info`, `debug`
**Default**: `info`
**Example**: `LOG_LEVEL=info`

#### 6. CORS_ORIGIN
**Purpose**: Allowed frontend domain for CORS
**Format**: `https://your-frontend-domain.com`
**Example**: `CORS_ORIGIN=https://task-manager-ui.onrender.com`
**Why**: Security - only allow requests from your frontend

#### 7. DATABASE_SSL
**Purpose**: Enable SSL for database connection
**Values**: `true` or `false`
**Default**: `false`
**Example**: `DATABASE_SSL=true`
**When to use**: Required by some platforms (DigitalOcean, Supabase)

#### 8. RATE_LIMIT_WINDOW_MS
**Purpose**: Rate limiting window in milliseconds
**Default**: `900000` (15 minutes)
**Example**: `RATE_LIMIT_WINDOW_MS=900000`

#### 9. RATE_LIMIT_MAX_REQUESTS
**Purpose**: Max requests per window
**Default**: `100`
**Example**: `RATE_LIMIT_MAX_REQUESTS=100`

#### 10. SENTRY_DSN
**Purpose**: Sentry error tracking
**Format**: `https://key@sentry.io/project-id`
**Example**: `SENTRY_DSN=https://abc123@sentry.io/123456`
**Optional**: Only if using Sentry

---

## 🎨 Frontend Environment Variables

### Required Variables

#### 1. VITE_API_URL
**Purpose**: Backend API base URL
**Format**: `https://your-backend-url/api/v1`
**Example**: `VITE_API_URL=https://task-manager-api.onrender.com/api/v1`
**Where to get**: Backend service URL from your platform
**Important**: Must include `/api/v1` at the end

### Optional Variables

#### 2. VITE_ANALYTICS_ID
**Purpose**: Google Analytics tracking ID
**Format**: `G-XXXXXXXXXX`
**Example**: `VITE_ANALYTICS_ID=G-ABC123DEF456`
**Optional**: Only if using Google Analytics

#### 3. VITE_SENTRY_DSN
**Purpose**: Sentry error tracking for frontend
**Format**: `https://key@sentry.io/project-id`
**Example**: `VITE_SENTRY_DSN=https://abc123@sentry.io/123456`
**Optional**: Only if using Sentry

#### 4. VITE_LOG_LEVEL
**Purpose**: Frontend logging level
**Values**: `error`, `warn`, `info`, `debug`
**Default**: `info`
**Example**: `VITE_LOG_LEVEL=info`

---

## 🚀 Platform-Specific Setup

### Render

**Backend Service Environment Variables**:
```
DATABASE_URL=postgresql://taskuser:password@dpg-abc123.render.com:5432/task_manager
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
NODE_ENV=production
PORT=5000
CORS_ORIGIN=https://task-manager-ui.onrender.com
```

**Frontend Service Environment Variables**:
```
VITE_API_URL=https://task-manager-api.onrender.com/api/v1
```

**How to add**:
1. Go to service
2. Click "Environment" tab
3. Click "Add Environment Variable"
4. Enter NAME and VALUE
5. Click "Save"
6. Service redeploys automatically

### Railway

**Backend Service Variables**:
```
NODE_ENV=production
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
PORT=5000
CORS_ORIGIN=https://your-frontend-url
```
(DATABASE_URL auto-generated from PostgreSQL)

**Frontend Service Variables**:
```
VITE_API_URL=https://your-backend-url/api/v1
```

**How to add**:
1. Go to service
2. Click "Variables" tab
3. Add variables
4. Service redeploys automatically

### Heroku

**Backend**:
```bash
heroku config:set DATABASE_URL="postgresql://..." -a task-manager-api
heroku config:set JWT_SECRET="797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137" -a task-manager-api
heroku config:set NODE_ENV="production" -a task-manager-api
heroku config:set PORT="5000" -a task-manager-api
heroku config:set CORS_ORIGIN="https://task-manager-ui.herokuapp.com" -a task-manager-api
```

**Frontend**:
```bash
heroku config:set VITE_API_URL="https://task-manager-api.herokuapp.com/api/v1" -a task-manager-ui
```

**View all**:
```bash
heroku config -a task-manager-api
```

### AWS (EC2 + RDS)

**Create .env file**:
```bash
cat > /home/ec2-user/task-manager/.env << 'EOF'
DATABASE_URL=postgresql://taskuser:password@task-manager-db.abc123.us-east-1.rds.amazonaws.com:5432/task_manager
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
NODE_ENV=production
PORT=5000
CORS_ORIGIN=https://your-frontend-url
EOF
```

**Or use AWS Systems Manager Parameter Store**:
```bash
aws ssm put-parameter \
  --name /task-manager/prod/database-url \
  --value "postgresql://..." \
  --type String

aws ssm put-parameter \
  --name /task-manager/prod/jwt-secret \
  --value "797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137" \
  --type SecureString
```

### DigitalOcean

**Create .env file**:
```bash
cat > /root/task-manager/.env << 'EOF'
DATABASE_URL=postgresql://doadmin:password@db-postgresql-nyc1-12345.ondigitalocean.com:25060/defaultdb?sslmode=require
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
NODE_ENV=production
PORT=5000
DATABASE_SSL=true
CORS_ORIGIN=https://your-frontend-url
EOF
```

### Supabase

**Backend Environment Variables**:
```
DATABASE_URL=postgresql://postgres:password@db.abc123.supabase.co:5432/postgres
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
NODE_ENV=production
PORT=5000
DATABASE_SSL=true
CORS_ORIGIN=https://your-frontend-url
```

**Frontend Environment Variables**:
```
VITE_API_URL=https://your-backend-url/api/v1
```

---

## 📊 Complete Environment Variables Checklist

### Backend (.env.production)

```env
# REQUIRED
DATABASE_URL=postgresql://user:password@host:5432/task_manager
JWT_SECRET=797a3e0baed7dcd24c3ef3198db72bf356a5c80aa7a8a050a0793030c59f1137
NODE_ENV=production
PORT=5000

# RECOMMENDED
CORS_ORIGIN=https://your-frontend-domain.com
LOG_LEVEL=info

# OPTIONAL
DATABASE_SSL=false
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
SENTRY_DSN=https://key@sentry.io/project-id
```

### Frontend (.env.production)

```env
# REQUIRED
VITE_API_URL=https://your-backend-url/api/v1

# OPTIONAL
VITE_ANALYTICS_ID=G-XXXXXXXXXX
VITE_SENTRY_DSN=https://key@sentry.io/project-id
VITE_LOG_LEVEL=info
```

---

## 🔒 Security Best Practices

### DO ✅
- Store secrets in environment variables (never in code)
- Use strong random values for JWT_SECRET
- Use different secrets for different environments
- Rotate secrets periodically (every 6-12 months)
- Keep DATABASE_URL secure
- Use HTTPS for CORS_ORIGIN
- Enable DATABASE_SSL when available

### DON'T ❌
- Commit .env files to git
- Share secrets via email or chat
- Use weak or predictable secrets
- Use same secret across environments
- Log or expose secrets
- Hardcode secrets in code
- Share DATABASE_URL publicly

---

## 🧪 Verify Environment Variables

### Check Backend Variables

```bash
# View all variables
heroku config -a task-manager-api

# Or check .env file
cat .env

# Test connection
DATABASE_URL="your-url" npm run prisma:migrate
```

### Check Frontend Variables

```bash
# View in browser console
console.log(import.meta.env.VITE_API_URL)

# Or check .env file
cat .env
```

---

## 🆘 Troubleshooting

### Variables Not Loading

**Problem**: Environment variables not being read

**Solutions**:
1. Check .env file exists
2. Check variable names are correct
3. Restart application
4. Check platform dashboard for variables
5. Verify no typos in variable names

### Database Connection Error

**Problem**: `DATABASE_URL` not working

**Solutions**:
1. Verify DATABASE_URL format
2. Test connection locally: `psql "your-url"`
3. Check host is correct
4. Check port is correct (usually 5432)
5. Check credentials are correct
6. Check database exists

### API URL Not Working

**Problem**: Frontend can't reach backend

**Solutions**:
1. Verify VITE_API_URL is correct
2. Check backend is running
3. Check CORS_ORIGIN is set correctly
4. Clear browser cache
5. Check network tab in DevTools

### JWT Secret Issues

**Problem**: Authentication not working

**Solutions**:
1. Verify JWT_SECRET is set
2. Check JWT_SECRET is strong (32+ bytes)
3. Verify JWT_SECRET is same across all instances
4. Check NODE_ENV=production

---

## 📋 Environment Variables Summary Table

| Variable | Backend | Frontend | Required | Example |
|----------|---------|----------|----------|---------|
| DATABASE_URL | ✅ | ❌ | Yes | postgresql://... |
| JWT_SECRET | ✅ | ❌ | Yes | 797a3e0b... |
| NODE_ENV | ✅ | ❌ | Yes | production |
| PORT | ✅ | ❌ | Yes | 5000 |
| VITE_API_URL | ❌ | ✅ | Yes | https://api.example.com/api/v1 |
| CORS_ORIGIN | ✅ | ❌ | No | https://frontend.example.com |
| LOG_LEVEL | ✅ | ✅ | No | info |
| DATABASE_SSL | ✅ | ❌ | No | true |
| SENTRY_DSN | ✅ | ✅ | No | https://key@sentry.io/... |
| VITE_ANALYTICS_ID | ❌ | ✅ | No | G-XXXXXXXXXX |

---

## 🎯 Quick Setup Checklist

### Before Deployment

- [ ] DATABASE_URL obtained from platform
- [ ] JWT_SECRET generated (32+ bytes)
- [ ] NODE_ENV set to "production"
- [ ] PORT set to 5000
- [ ] VITE_API_URL set to backend URL
- [ ] CORS_ORIGIN set to frontend URL
- [ ] All variables added to platform
- [ ] Variables tested locally
- [ ] No secrets in git
- [ ] Backups configured

---

## 📞 Support

- **Render**: https://render.com/docs/environment-variables
- **Railway**: https://docs.railway.app/develop/variables
- **Heroku**: https://devcenter.heroku.com/articles/config-vars
- **AWS**: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html

---

**Your environment variables are ready! 🚀**
