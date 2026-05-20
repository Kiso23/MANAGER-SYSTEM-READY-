# Task Manager - Production Deployment Guide

Complete guide to deploy your Task Manager to production.

## 🎯 Deployment Options

Choose one of these platforms:

### **Option 1: Render (Recommended - Easiest)**
- Free tier available
- Auto-deploys from GitHub
- Built-in PostgreSQL
- SSL included
- No credit card for free tier

### **Option 2: Railway**
- Simple deployment
- Pay-as-you-go pricing
- GitHub integration
- PostgreSQL included

### **Option 3: Heroku**
- Popular choice
- Easy deployment
- PostgreSQL add-on
- Requires credit card

### **Option 4: AWS (Most Scalable)**
- EC2 for backend
- RDS for database
- S3 + CloudFront for frontend
- More complex setup

---

## 🚀 OPTION 1: Deploy to Render (Recommended)

### Step 1: Prepare Backend for Production

Update `backend/.env.production`:

```env
DATABASE_URL="postgresql://user:password@your-render-db:5432/task_manager"
JWT_SECRET="generate-a-strong-random-secret-key-here"
NODE_ENV="production"
PORT=5000
```

Generate a strong JWT secret:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Step 2: Create Render Account

1. Go to https://render.com
2. Sign up with GitHub
3. Click "New +"

### Step 3: Deploy Backend

1. Click "New Web Service"
2. Connect your GitHub repository
3. Configure:
   - **Name**: `task-manager-api`
   - **Environment**: `Node`
   - **Build Command**: `npm install && npm run build && npm run prisma:migrate`
   - **Start Command**: `npm start`
   - **Plan**: Free (or Starter)

4. Add Environment Variables:
   ```
   DATABASE_URL=postgresql://...
   JWT_SECRET=your-secret-key
   NODE_ENV=production
   ```

5. Click "Create Web Service"

### Step 4: Create PostgreSQL Database

1. Click "New +"
2. Select "PostgreSQL"
3. Configure:
   - **Name**: `task-manager-db`
   - **Database**: `task_manager`
   - **User**: `taskuser`
   - **Plan**: Free

4. Copy the connection string to `DATABASE_URL`

### Step 5: Deploy Frontend

1. Click "New +"
2. Select "Static Site"
3. Connect your GitHub repository
4. Configure:
   - **Name**: `task-manager-ui`
   - **Build Command**: `cd frontend && npm install && npm run build`
   - **Publish Directory**: `frontend/dist`

5. Add Environment Variable:
   ```
   VITE_API_URL=https://task-manager-api.onrender.com/api/v1
   ```

6. Click "Create Static Site"

### Step 6: Verify Deployment

1. Wait for both services to deploy (5-10 minutes)
2. Visit your frontend URL
3. Test registration and login
4. Check API docs at `https://task-manager-api.onrender.com/api-docs`

---

## 🚀 OPTION 2: Deploy to Railway

### Step 1: Create Railway Account

1. Go to https://railway.app
2. Sign up with GitHub
3. Create new project

### Step 2: Add PostgreSQL

1. Click "Add Service"
2. Select "PostgreSQL"
3. Railway auto-generates connection string

### Step 3: Deploy Backend

1. Click "Add Service"
2. Select "GitHub Repo"
3. Connect your repository
4. Configure:
   - **Root Directory**: `backend`
   - **Start Command**: `npm start`

5. Add Variables:
   ```
   DATABASE_URL=postgresql://...
   JWT_SECRET=your-secret-key
   NODE_ENV=production
   PORT=5000
   ```

### Step 4: Deploy Frontend

1. Click "Add Service"
2. Select "GitHub Repo"
3. Connect your repository
4. Configure:
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Start Command**: `npm run preview`

5. Add Variable:
   ```
   VITE_API_URL=https://your-backend-url/api/v1
   ```

---

## 🚀 OPTION 3: Deploy to Heroku

### Step 1: Install Heroku CLI

```bash
# macOS
brew tap heroku/brew && brew install heroku

# Ubuntu/Linux
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

# Windows
# Download from https://devcenter.heroku.com/articles/heroku-cli
```

### Step 2: Login to Heroku

```bash
heroku login
```

### Step 3: Create Heroku Apps

```bash
# Create backend app
heroku create task-manager-api

# Create frontend app
heroku create task-manager-ui

# Create PostgreSQL database
heroku addons:create heroku-postgresql:hobby-dev -a task-manager-api
```

### Step 4: Configure Backend

```bash
# Set environment variables
heroku config:set JWT_SECRET="your-secret-key" -a task-manager-api
heroku config:set NODE_ENV="production" -a task-manager-api

# Get database URL
heroku config:get DATABASE_URL -a task-manager-api
```

### Step 5: Deploy Backend

```bash
cd backend
git push heroku main
```

### Step 6: Deploy Frontend

```bash
cd frontend

# Create Procfile
echo "web: npm run preview" > Procfile

# Deploy
git push heroku main
```

---

## 🔐 Production Security Checklist

### Backend Security

- [ ] Change `JWT_SECRET` to a strong random value
- [ ] Set `NODE_ENV=production`
- [ ] Use HTTPS only (auto-enabled on Render/Railway/Heroku)
- [ ] Enable CORS for your frontend domain only
- [ ] Use environment variables for all secrets
- [ ] Enable database SSL connections
- [ ] Set up database backups
- [ ] Monitor error logs
- [ ] Set up rate limiting
- [ ] Enable security headers

### Frontend Security

- [ ] Update `VITE_API_URL` to production backend URL
- [ ] Remove console.log statements
- [ ] Enable HTTPS
- [ ] Set security headers
- [ ] Enable CSP (Content Security Policy)
- [ ] Test all authentication flows
- [ ] Verify token refresh works

### Database Security

- [ ] Use strong database password
- [ ] Enable SSL connections
- [ ] Set up automated backups
- [ ] Restrict database access to backend only
- [ ] Monitor database performance
- [ ] Set up database monitoring alerts

---

## 📊 Environment Variables

### Backend Production (.env.production)

```env
# Database
DATABASE_URL="postgresql://user:password@host:5432/task_manager"

# JWT
JWT_SECRET="generate-strong-random-secret"

# Environment
NODE_ENV="production"
PORT=5000

# Optional: Logging
LOG_LEVEL="info"

# Optional: Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

### Frontend Production (.env.production)

```env
# API
VITE_API_URL="https://your-backend-url/api/v1"

# Optional: Analytics
VITE_ANALYTICS_ID="your-analytics-id"
```

---

## 🔄 CI/CD Pipeline (GitHub Actions)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy Backend
        run: |
          git push https://heroku:${{ secrets.HEROKU_API_KEY }}@git.heroku.com/task-manager-api.git main
      
      - name: Deploy Frontend
        run: |
          git push https://heroku:${{ secrets.HEROKU_API_KEY }}@git.heroku.com/task-manager-ui.git main
```

---

## 📈 Monitoring & Logging

### Set Up Monitoring

1. **Error Tracking**: Sentry
   ```bash
   npm install @sentry/node
   ```

2. **Performance Monitoring**: New Relic
   ```bash
   npm install newrelic
   ```

3. **Logging**: LogRocket (Frontend)
   ```bash
   npm install logrocket
   ```

### View Logs

**Render:**
```bash
# View logs in dashboard or CLI
render logs task-manager-api
```

**Railway:**
```bash
# View logs in dashboard
```

**Heroku:**
```bash
heroku logs --tail -a task-manager-api
```

---

## 🔧 Database Migrations in Production

### Render/Railway

Migrations run automatically during deployment via build command:
```
npm run prisma:migrate
```

### Manual Migration

```bash
# Connect to production database
DATABASE_URL="your-production-url" npm run prisma:migrate

# Or use Prisma Studio
DATABASE_URL="your-production-url" npm run prisma:studio
```

---

## 🚨 Troubleshooting Production Issues

### Backend Won't Start

```bash
# Check logs
heroku logs --tail -a task-manager-api

# Check environment variables
heroku config -a task-manager-api

# Restart app
heroku restart -a task-manager-api
```

### Database Connection Error

```bash
# Verify DATABASE_URL
heroku config:get DATABASE_URL -a task-manager-api

# Test connection
psql your-database-url
```

### Frontend Can't Connect to Backend

1. Check `VITE_API_URL` is correct
2. Verify backend is running
3. Check CORS settings
4. Clear browser cache

### High Memory Usage

```bash
# Upgrade dyno type
heroku dyno:type standard-1x -a task-manager-api
```

---

## 📊 Performance Optimization

### Backend Optimization

1. **Enable Caching**
   ```bash
   npm install redis
   ```

2. **Database Connection Pooling**
   ```env
   DATABASE_URL="postgresql://...?schema=public&connection_limit=5"
   ```

3. **Compression**
   ```bash
   npm install compression
   ```

4. **Load Balancing**
   - Use Render/Railway auto-scaling

### Frontend Optimization

1. **Code Splitting**
   - Vite does this automatically

2. **Image Optimization**
   - Use WebP format
   - Lazy load images

3. **CDN**
   - Render/Railway/Heroku include CDN
   - Or use Cloudflare

---

## 💰 Cost Estimation

### Render (Recommended)

- **Backend**: Free tier or $7/month
- **Database**: Free tier or $15/month
- **Frontend**: Free tier or $5/month
- **Total**: Free - $27/month

### Railway

- **Pay-as-you-go**: ~$5-20/month
- **Includes**: Backend, Database, Frontend

### Heroku

- **Backend**: $7/month (Eco)
- **Database**: $9/month (Hobby)
- **Frontend**: $7/month (Eco)
- **Total**: ~$23/month

### AWS

- **EC2**: $5-50/month
- **RDS**: $15-100/month
- **S3 + CloudFront**: $1-10/month
- **Total**: $20-160/month

---

## 🔄 Continuous Deployment

### Auto-Deploy on Push

**Render/Railway/Heroku** automatically deploy when you push to main:

```bash
git push origin main
# Automatically deploys to production
```

### Manual Deployment

```bash
# Render
render deploy task-manager-api

# Railway
railway deploy

# Heroku
git push heroku main
```

---

## 📋 Production Checklist

- [ ] Generate strong JWT_SECRET
- [ ] Set NODE_ENV=production
- [ ] Configure DATABASE_URL
- [ ] Update VITE_API_URL in frontend
- [ ] Enable HTTPS
- [ ] Set up database backups
- [ ] Configure monitoring/logging
- [ ] Test all features in production
- [ ] Set up error tracking
- [ ] Configure rate limiting
- [ ] Enable security headers
- [ ] Set up CI/CD pipeline
- [ ] Document deployment process
- [ ] Create runbook for incidents
- [ ] Set up uptime monitoring

---

## 🎯 Quick Deployment Summary

### Fastest Way (Render)

1. Push code to GitHub
2. Create Render account
3. Deploy backend (5 min)
4. Deploy database (2 min)
5. Deploy frontend (5 min)
6. Update environment variables
7. Done! ✅

**Total Time: ~15 minutes**

---

## 📞 Support

- **Render Support**: https://render.com/docs
- **Railway Support**: https://docs.railway.app
- **Heroku Support**: https://devcenter.heroku.com
- **AWS Support**: https://aws.amazon.com/support

---

**Your Task Manager is production-ready! 🚀**
