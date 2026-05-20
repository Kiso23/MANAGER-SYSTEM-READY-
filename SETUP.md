# Task Manager - Complete Setup Guide

This guide will help you set up and run the Task Manager application locally.

## 📋 Prerequisites

Before you start, ensure you have:

- **Node.js**: v18+ (v20+ recommended)
  - Download: https://nodejs.org/
  - Verify: `node --version` and `npm --version`

- **PostgreSQL**: v12+
  - Download: https://www.postgresql.org/download/
  - Verify: `psql --version`

- **Git**: For version control
  - Download: https://git-scm.com/

- **Docker** (Optional): For containerized setup
  - Download: https://www.docker.com/

## 🚀 Option 1: Local Development Setup

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd task-manager
```

### Step 2: Setup PostgreSQL Database

#### On macOS (using Homebrew):
```bash
brew install postgresql
brew services start postgresql
createdb task_manager
```

#### On Windows:
1. Download PostgreSQL installer
2. Run installer and follow prompts
3. Remember the password you set
4. Open pgAdmin and create database `task_manager`

#### On Linux:
```bash
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo -u postgres createdb task_manager
```

### Step 3: Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
DATABASE_URL="postgresql://postgres:password@localhost:5432/task_manager"
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"
NODE_ENV="development"
PORT=5000
EOF

# Update DATABASE_URL with your PostgreSQL credentials

# Run database migrations
npm run prisma:migrate

# Start development server
npm run dev
```

Backend will run on `http://localhost:5000`

### Step 4: Setup Frontend

In a new terminal:

```bash
cd frontend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
VITE_API_URL=http://localhost:5000/api/v1
EOF

# Start development server
npm run dev
```

Frontend will run on `http://localhost:3000`

### Step 5: Test the Application

1. Open `http://localhost:3000` in your browser
2. Click "Register" to create a new account
3. Fill in the registration form
4. Create and manage tasks

## 🐳 Option 2: Docker Setup

### Prerequisites
- Docker Desktop installed and running

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd task-manager
```

### Step 2: Start with Docker Compose

```bash
docker-compose up
```

This will:
- Start PostgreSQL database
- Build and start backend
- Build and start frontend

Wait for all services to be healthy (2-3 minutes).

### Step 3: Access the Application

- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:5000`
- API Docs: `http://localhost:5000/api-docs`
- Database: `localhost:5432`

### Step 4: Stop Services

```bash
docker-compose down
```

## 🔧 Configuration

### Backend Environment Variables

Create `backend/.env`:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/task_manager"

# JWT
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"

# Environment
NODE_ENV="development"  # or "production"
PORT=5000
```

### Frontend Environment Variables

Create `frontend/.env`:

```env
VITE_API_URL=http://localhost:5000/api/v1
```

## 📚 Available Commands

### Backend

```bash
cd backend

# Development
npm run dev              # Start dev server with hot reload

# Database
npm run prisma:migrate   # Run migrations
npm run prisma:generate  # Generate Prisma Client
npm run prisma:studio    # Open Prisma Studio GUI

# Production
npm run build            # Build TypeScript
npm start                # Run production server
```

### Frontend

```bash
cd frontend

# Development
npm run dev              # Start dev server

# Production
npm run build            # Build for production
npm run preview          # Preview production build
```

## 🧪 Testing the API

### Using cURL

#### Register User
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

#### Login
```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

Copy the `token` from the response.

#### Get Tasks
```bash
curl -X GET http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### Create Task
```bash
curl -X POST http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Task",
    "description": "This is my first task"
  }'
```

### Using Swagger UI

1. Start the backend: `npm run dev` (in backend directory)
2. Open `http://localhost:5000/api-docs`
3. Try out endpoints directly from the UI

## 🔐 Creating Admin User

To create an admin user, you need to modify the database directly:

### Using Prisma Studio

```bash
cd backend
npm run prisma:studio
```

1. Open the User table
2. Create a new user
3. Set role to "ADMIN"

### Using SQL

```bash
psql -U postgres -d task_manager

UPDATE "User" SET role = 'ADMIN' WHERE email = 'admin@example.com';
```

## 🐛 Troubleshooting

### PostgreSQL Connection Error

**Error**: `connect ECONNREFUSED 127.0.0.1:5432`

**Solution**:
1. Ensure PostgreSQL is running: `brew services list` (macOS)
2. Check DATABASE_URL in .env
3. Verify database exists: `psql -l`

### Port Already in Use

**Error**: `EADDRINUSE: address already in use :::5000`

**Solution**:
```bash
# Find process using port 5000
lsof -i :5000

# Kill the process
kill -9 <PID>
```

### Module Not Found

**Error**: `Cannot find module 'express'`

**Solution**:
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Database Migration Error

**Error**: `Migration failed`

**Solution**:
```bash
# Reset database (WARNING: deletes all data)
npm run prisma:migrate reset

# Or manually drop and recreate
psql -U postgres -d task_manager -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
npm run prisma:migrate dev
```

### Frontend Can't Connect to Backend

**Error**: `Network Error` or `CORS error`

**Solution**:
1. Ensure backend is running on port 5000
2. Check VITE_API_URL in frontend .env
3. Verify backend CORS is enabled
4. Clear browser cache and localStorage

## 📦 Building for Production

### Backend

```bash
cd backend

# Build
npm run build

# Start production server
npm start
```

### Frontend

```bash
cd frontend

# Build
npm run build

# Preview production build
npm run preview
```

## 🚀 Deployment

### Deploy Backend to Render

1. Push code to GitHub
2. Create new Web Service on Render
3. Connect your repository
4. Set environment variables:
   - `DATABASE_URL`: Your production database URL
   - `JWT_SECRET`: Strong random secret
   - `NODE_ENV`: production
5. Deploy

### Deploy Frontend to Vercel

1. Push code to GitHub
2. Import project in Vercel
3. Set environment variables:
   - `VITE_API_URL`: Your backend URL
4. Deploy

## 📝 Project Structure

```
task-manager/
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── routes/
│   │   ├── utils/
│   │   ├── app.ts
│   │   └── server.ts
│   ├── prisma/
│   │   └── schema.prisma
│   ├── .env
│   ├── Dockerfile
│   ├── package.json
│   └── README.md
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── context/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── .env
│   ├── Dockerfile
│   ├── vite.config.ts
│   ├── tailwind.config.js
│   ├── package.json
│   └── README.md
│
├── docker-compose.yml
├── .gitignore
├── README.md
└── SETUP.md
```

## ✅ Verification Checklist

- [ ] Node.js v18+ installed
- [ ] PostgreSQL installed and running
- [ ] Backend dependencies installed
- [ ] Frontend dependencies installed
- [ ] Database migrations run
- [ ] Backend running on port 5000
- [ ] Frontend running on port 3000
- [ ] Can register new user
- [ ] Can login
- [ ] Can create tasks
- [ ] Can view tasks
- [ ] Can update tasks
- [ ] Can delete tasks

## 📞 Getting Help

1. Check the README files in backend/ and frontend/
2. Review API documentation at `http://localhost:5000/api-docs`
3. Check error messages in console
4. Review troubleshooting section above

## 🎓 Next Steps

1. Explore the codebase
2. Read the backend and frontend README files
3. Try the API endpoints
4. Customize the application
5. Deploy to production

---

**Happy coding! 🚀**
