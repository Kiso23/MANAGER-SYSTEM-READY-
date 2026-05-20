# Deploy to Render - Step by Step Guide

Complete guide to deploy Task Manager to Render (Recommended for beginners).

## ✅ Why Render?

- ✅ Free tier available
- ✅ Auto-deploys from GitHub
- ✅ Built-in PostgreSQL
- ✅ SSL included
- ✅ No credit card for free tier
- ✅ Easy to use
- ✅ Great documentation

## 🚀 Step 1: Prepare Your GitHub Repository

Make sure your code is pushed to GitHub:

```bash
git add .
git commit -m "Production ready"
git push origin main
```

## 🚀 Step 2: Create Render Account

1. Go to https://render.com
2. Click "Sign up"
3. Choose "Sign up with GitHub"
4. Authorize Render to access your GitHub account
5. Complete signup

## 🚀 Step 3: Create PostgreSQL Database

1. In Render dashboard, click "New +"
2. Select "PostgreSQL"
3. Configure:
   - **Name**: `task-manager-db`
   - **Database**: `task_manager`
   - **User**: `taskuser`
   - **Region**: Choose closest to you
   - **Plan**: Free (or Starter)
4. Click "Create Database"
5. Wait for database to be created (2-3 minutes)
6. Copy the connection string (you'll need it)

**Connection String Format:**
```
postgresql://taskuser:password@host:5432/task_manager
```

## 🚀 Step 4: Deploy Backend

1. In Render dashboard, click "New +"
2. Select "Web Service"
3. Choose "Deploy an existing repository"
4. Select your GitHub repository
5. Configure:
   - **Name**: `task-manager-api`
   - **Environment**: `Node`
   - **Build Command**: 
     ```
     npm install && npm run build && npm run prisma:migrate
     ```
   - **Start Command**: 
     ```
     npm start
     ```
   - **Plan**: Free (or Starter)
   - **Root Directory**: `backend`

6. Click "Create Web Service"

7. Add Environment Variables:
   - Click "Environment" in left sidebar
   - Add these variables:
     ```
     DATABASE_URL=postgresql://taskuser:password@host:5432/task_manager
     JWT_SECRET=your-strong-random-secret-key
     NODE_ENV=production
     PORT=5000
     ```

8. Wait for deployment (5-10 minutes)

9. Copy your backend URL (e.g., `https://task-manager-api.onrender.com`)

## 🚀 Step 5: Deploy Frontend

1. In Render dashboard, click "New +"
2. Select "Static Site"
3. Choose "Deploy an existing repository"
4. Select your GitHub repository
5. Configure:
   - **Name**: `task-manager-ui`
   - **Build Command**: 
     ```
     cd frontend && npm install && npm run build
     ```
   - **Publish Directory**: 
     ```
     frontend/dist
     ```
   - **Root Directory**: (leave empty)

6. Click "Create Static Site"

7. Add Environment Variable:
   - Click "Environment" in left sidebar
   - Add:
     ```
     VITE_API_URL=https://task-manager-api.onrender.com/api/v1
     ```

8. Wait for deployment (3-5 minutes)

9. Copy your frontend URL (e.g., `https://task-manager-ui.onrender.com`)

## ✅ Step 6: Verify Deployment

1. Open your frontend URL in browser
2. You should see the Task Manager home page
3. Click "Register" and create an account
4. Test creating a task
5. Check API docs at `https://task-manager-api.onrender.com/api-docs`

## 🔐 Step 7: Generate Strong JWT Secret

Replace the JWT_SECRET with a strong random value:

```bash
# Generate strong secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Copy the output and update in Render:
1. Go to backend service
2. Click "Environment"
3. Update JWT_SECRET
4. Click "Save"
5. Service will redeploy automatically

## 📊 Step 8: Monitor Your Application

### View Logs
1. Go to backend service
2. Click "Logs" tab
3. See real-time logs

### Check Health
1. Visit `https://task-manager-api.onrender.com/health`
2. Should return `{"status":"OK"}`

### Monitor Database
1. Go to PostgreSQL database
2. Click "Info" tab
3. See connection info and stats

## 🔄 Step 9: Set Up Auto-Deploys

Render automatically deploys when you push to GitHub:

```bash
# Make changes
git add .
git commit -m "Update feature"
git push origin main

# Render automatically deploys!
```

## 🆘 Troubleshooting

### Backend won't start

**Check logs:**
1. Go to backend service
2. Click "Logs"
3. Look for error messages

**Common issues:**
- Database connection error → Check DATABASE_URL
- Migration failed → Check database exists
- Port already in use → Change PORT variable

### Frontend shows blank page

**Check browser console:**
1. Open browser DevTools (F12)
2. Check Console tab for errors
3. Check Network tab for API calls

**Common issues:**
- API URL wrong → Check VITE_API_URL
- CORS error → Check backend CORS settings
- 404 errors → Check backend is running

### Can't connect to database

**Verify connection string:**
```bash
# Test connection locally
psql "postgresql://taskuser:password@host:5432/task_manager"
```

**Check Render database:**
1. Go to PostgreSQL service
2. Click "Info"
3. Verify connection string
4. Check database exists

### Migrations not running

**Run manually:**
1. Go to backend service
2. Click "Shell"
3. Run:
   ```bash
   npm run prisma:migrate
   ```

## 📈 Performance Tips

### Optimize Backend
- Use Starter plan for better performance
- Enable caching
- Optimize database queries
- Use connection pooling

### Optimize Frontend
- Enable gzip compression
- Optimize images
- Use CDN (Render includes this)
- Lazy load components

### Optimize Database
- Create indexes on frequently queried columns
- Archive old data
- Use connection pooling
- Monitor slow queries

## 💰 Pricing

### Free Tier
- Backend: Free (sleeps after 15 min inactivity)
- Database: Free (limited storage)
- Frontend: Free
- **Total**: Free

### Starter Plan
- Backend: $7/month
- Database: $15/month
- Frontend: $5/month
- **Total**: $27/month

### Production Plan
- Backend: $12/month
- Database: $30/month
- Frontend: $20/month
- **Total**: $62/month

## 🔐 Security Checklist

- [ ] JWT_SECRET is strong (32+ characters)
- [ ] DATABASE_URL uses SSL
- [ ] NODE_ENV=production
- [ ] CORS configured for frontend domain
- [ ] HTTPS enabled (automatic)
- [ ] Database backups enabled
- [ ] Monitoring enabled
- [ ] Error tracking enabled

## 📞 Support

- **Render Docs**: https://render.com/docs
- **Render Support**: https://render.com/support
- **Status Page**: https://status.render.com

## 🎯 Next Steps

1. ✅ Deploy to Render
2. ✅ Test all features
3. ✅ Set up monitoring
4. ✅ Configure backups
5. ✅ Share with users
6. ✅ Monitor performance

---

**Your Task Manager is now live on Render! 🚀**

**Frontend**: https://task-manager-ui.onrender.com
**Backend**: https://task-manager-api.onrender.com
**API Docs**: https://task-manager-api.onrender.com/api-docs
