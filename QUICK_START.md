# Task Manager - Quick Start Guide

Get up and running in 5 minutes!

## 🚀 Fastest Way to Start

### Prerequisites
- Node.js v18+
- PostgreSQL running locally

### Step 1: Backend (2 minutes)

```bash
cd backend
npm install
npm run prisma:migrate
npm run dev
```

✅ Backend running on `http://localhost:5000`

### Step 2: Frontend (2 minutes)

In a new terminal:

```bash
cd frontend
npm install
npm run dev
```

✅ Frontend running on `http://localhost:3000`

### Step 3: Test (1 minute)

1. Open `http://localhost:3000`
2. Click "Register"
3. Create an account
4. Create a task
5. Done! 🎉

---

## 🐳 Docker Quick Start (Even Faster!)

```bash
docker-compose up
```

Wait 2-3 minutes, then open `http://localhost:3000`

---

## 📝 Test Credentials

After registering, use these to test:

**User Account**
- Email: `user@example.com`
- Password: `password123`

**Admin Account** (requires manual database update)
- Email: `admin@example.com`
- Password: `password123`

---

## 🔗 Important URLs

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:5000 |
| API Docs | http://localhost:5000/api-docs |
| Database | localhost:5432 |

---

## 📚 Key Files to Understand

### Backend
- `src/app.ts` - Express setup
- `src/controllers/` - Business logic
- `src/routes/` - API endpoints
- `prisma/schema.prisma` - Database schema

### Frontend
- `src/App.tsx` - Main component
- `src/pages/` - Page components
- `src/services/api.ts` - API client
- `src/context/AuthContext.tsx` - Auth state

---

## 🧪 Quick API Test

### Register
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

Copy the `token` from response.

### Create Task
```bash
curl -X POST http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Task",
    "description": "Task description"
  }'
```

---

## 🆘 Common Issues

### Port Already in Use
```bash
# Kill process on port 5000
lsof -i :5000
kill -9 <PID>
```

### Database Connection Error
```bash
# Check PostgreSQL is running
psql -U postgres

# Create database if needed
createdb task_manager
```

### Dependencies Not Installing
```bash
rm -rf node_modules package-lock.json
npm install
```

---

## 📖 Full Documentation

- **Setup Guide**: See `SETUP.md`
- **Backend Docs**: See `backend/README.md`
- **Frontend Docs**: See `frontend/README.md`
- **Project Overview**: See `README.md`

---

## 🎯 What to Try Next

1. ✅ Register a new user
2. ✅ Create a task
3. ✅ Mark task as complete
4. ✅ Delete a task
5. ✅ Check API docs at `/api-docs`
6. ✅ Try different endpoints
7. ✅ Explore the code
8. ✅ Customize the UI
9. ✅ Add new features
10. ✅ Deploy to production

---

## 🚀 Ready to Deploy?

### Backend
- Render: https://render.com
- Railway: https://railway.app
- Heroku: https://heroku.com

### Frontend
- Vercel: https://vercel.com
- Netlify: https://netlify.com

### Database
- Render PostgreSQL
- Railway PostgreSQL
- AWS RDS

---

## 💡 Pro Tips

1. **Use Swagger UI** - Visit `/api-docs` to test API endpoints
2. **Check Prisma Studio** - Run `npm run prisma:studio` to view database
3. **Use DevTools** - Open browser DevTools to see network requests
4. **Read Error Messages** - They usually tell you exactly what's wrong
5. **Check Console Logs** - Both browser and terminal show helpful info

---

## 📞 Need Help?

1. Check the README files
2. Review SETUP.md troubleshooting
3. Check browser console for errors
4. Check terminal for error messages
5. Review the code comments

---

**You're all set! Happy coding! 🚀**
