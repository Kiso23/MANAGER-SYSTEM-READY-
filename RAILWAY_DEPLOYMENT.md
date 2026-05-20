# Deploy to Railway - Step by Step Guide

Complete guide to deploy Task Manager to Railway.

## ✅ Why Railway?

- ✅ Simple deployment
- ✅ Pay-as-you-go pricing
- ✅ GitHub integration
- ✅ PostgreSQL included
- ✅ Auto-scaling
- ✅ Good documentation
- ✅ Affordable

## 🚀 Step 1: Create Railway Account

1. Go to https://railway.app
2. Click "Start Project"
3. Choose "Deploy from GitHub"
4. Authorize Railway to access GitHub
5. Complete signup

## 🚀 Step 2: Create New Project

1. In Railway dashboard, click "New Project"
2. Select "Provision PostgreSQL"
3. Railway creates a new project with PostgreSQL

## 🚀 Step 3: Add Backend Service

1. Click "Add Service"
2. Select "GitHub Repo"
3. Select your repository
4. Configure:
   - **Root Directory**: `backend`
   - **Start Command**: `npm start`
   - **Build Command**: `npm install && npm run build`

5. Click "Deploy"

6. Add Environment Variables:
   - Click "Variables" tab
   - Add:
     ```
     NODE_ENV=production
     JWT_SECRET=your-strong-random-secret
     PORT=5000
     ```

7. Railway auto-generates DATABASE_URL from PostgreSQL

## 🚀 Step 4: Add Frontend Service

1. Click "Add Service"
2. Select "GitHub Repo"
3. Select your repository
4. Configure:
   - **Root Directory**: `frontend`
   - **Build Command**: `cd frontend && npm install && npm run build`
   - **Start Command**: `npm run preview`

5. Click "Deploy"

6. Add Environment Variable:
   - Click "Variables" tab
   - Add:
     ```
     VITE_API_URL=https://your-backend-url/api/v1
     ```

## 🚀 Step 5: Get Service URLs

1. Go to backend service
2. Click "Settings"
3. Copy the public URL
4. Update frontend VITE_API_URL with this URL

## ✅ Step 6: Verify Deployment

1. Open frontend URL
2. Register and test features
3. Check API docs at backend URL + `/api-docs`

## 🔐 Step 7: Configure Production Settings

### Generate Strong JWT Secret

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Update in Railway:
1. Go to backend service
2. Click "Variables"
3. Update JWT_SECRET
4. Service redeploys automatically

### Enable Database Backups

1. Go to PostgreSQL service
2. Click "Settings"
3. Enable automated backups

## 📊 Step 8: Monitor Application

### View Logs
1. Click service
2. Click "Logs" tab
3. See real-time logs

### Check Metrics
1. Click service
2. Click "Metrics" tab
3. See CPU, memory, network usage

### Database Monitoring
1. Click PostgreSQL service
2. Click "Metrics" tab
3. See database stats

## 🔄 Step 9: Auto-Deploy from GitHub

Railway automatically deploys when you push to GitHub:

```bash
git add .
git commit -m "Update feature"
git push origin main
# Railway automatically deploys!
```

## 🆘 Troubleshooting

### Service won't start

**Check logs:**
1. Click service
2. Click "Logs"
3. Look for error messages

**Common issues:**
- Missing environment variables
- Build command failed
- Port already in use

### Can't connect to database

**Check DATABASE_URL:**
1. Go to PostgreSQL service
2. Click "Variables"
3. Copy DATABASE_URL
4. Verify it's set in backend service

### Frontend can't reach backend

**Check VITE_API_URL:**
1. Go to frontend service
2. Click "Variables"
3. Verify VITE_API_URL is correct
4. Should be: `https://backend-url/api/v1`

## 📈 Performance Tips

### Optimize Backend
- Use appropriate plan
- Enable caching
- Optimize queries
- Monitor metrics

### Optimize Frontend
- Minimize bundle size
- Lazy load components
- Optimize images
- Use CDN

### Optimize Database
- Create indexes
- Monitor slow queries
- Archive old data
- Use connection pooling

## 💰 Pricing

Railway uses pay-as-you-go pricing:

- **Compute**: $0.000417/hour per vCPU
- **Memory**: $0.000050/hour per GB
- **Storage**: $0.10/GB/month
- **Network**: $0.10/GB outbound

**Estimated costs:**
- Small app: $5-15/month
- Medium app: $15-50/month
- Large app: $50-200/month

## 🔐 Security Checklist

- [ ] JWT_SECRET is strong
- [ ] NODE_ENV=production
- [ ] Database backups enabled
- [ ] HTTPS enabled (automatic)
- [ ] CORS configured
- [ ] Monitoring enabled
- [ ] Error tracking enabled

## 📞 Support

- **Railway Docs**: https://docs.railway.app
- **Railway Support**: https://railway.app/support
- **Status Page**: https://status.railway.app

## 🎯 Next Steps

1. ✅ Deploy to Railway
2. ✅ Test all features
3. ✅ Set up monitoring
4. ✅ Configure backups
5. ✅ Share with users
6. ✅ Monitor costs

---

**Your Task Manager is now live on Railway! 🚀**
