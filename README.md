# Task Manager - Full Stack Application

A production-ready, scalable task management system with Role-Based Access Control (RBAC), built with modern technologies.

## 🎯 Project Overview

This is a complete full-stack application featuring:

- **Backend**: Node.js + Express + TypeScript + PostgreSQL + Prisma
- **Frontend**: React + TypeScript + Vite + Tailwind CSS
- **Authentication**: JWT + bcryptjs
- **Documentation**: Swagger/OpenAPI
- **Deployment Ready**: Docker support

## 📁 Project Structure

```
task-manager/
├── backend/                 # Node.js Express API
│   ├── src/
│   │   ├── controllers/     # Business logic
│   │   ├── middleware/      # Auth, error handling
│   │   ├── routes/          # API endpoints
│   │   ├── utils/           # JWT, validators
│   │   ├── app.ts           # Express setup
│   │   └── server.ts        # Server entry
│   ├── prisma/
│   │   └── schema.prisma    # Database schema
│   ├── .env                 # Environment variables
│   ├── package.json
│   └── README.md
│
├── frontend/                # React Vite app
│   ├── src/
│   │   ├── components/      # Reusable components
│   │   ├── context/         # Auth context
│   │   ├── pages/           # Page components
│   │   ├── services/        # API client
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── .env                 # Environment variables
│   ├── vite.config.ts
│   ├── tailwind.config.js
│   ├── package.json
│   └── README.md
│
├── docker-compose.yml       # Docker orchestration
├── Dockerfile.backend       # Backend Docker image
├── Dockerfile.frontend      # Frontend Docker image
└── README.md               # This file
```

## 🚀 Quick Start

### Prerequisites

- Node.js v18+ (v20+ recommended)
- PostgreSQL 12+
- npm or yarn
- Docker (optional)

### Option 1: Local Development

#### Backend Setup

```bash
cd backend
npm install
npm run prisma:migrate
npm run dev
```

Backend runs on `http://localhost:5000`
API Docs: `http://localhost:5000/api-docs`

#### Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

Frontend runs on `http://localhost:3000`

### Option 2: Docker

```bash
docker-compose up
```

This starts:
- PostgreSQL on port 5432
- Backend on port 5000
- Frontend on port 3000

## 🔐 Authentication

### Register
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

Response includes JWT token to use in subsequent requests.

## 📚 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user

### Tasks (Protected)
- `GET /api/v1/tasks` - Get tasks (users see own, admins see all)
- `POST /api/v1/tasks` - Create task
- `PUT /api/v1/tasks/:id` - Update task
- `DELETE /api/v1/tasks/:id` - Delete task

### Documentation
- `GET /api-docs` - Swagger UI

## 👥 User Roles

### USER Role
- Create own tasks
- View own tasks
- Update own tasks
- Delete own tasks

### ADMIN Role
- Create tasks
- View all tasks
- Update any task
- Delete any task

## 🗄️ Database Schema

### User Table
```sql
- id (UUID, PK)
- name (String)
- email (String, Unique)
- password (String, hashed)
- role (Enum: USER, ADMIN)
- createdAt (DateTime)
- updatedAt (DateTime)
```

### Task Table
```sql
- id (UUID, PK)
- title (String)
- description (String, optional)
- completed (Boolean)
- userId (UUID, FK)
- createdAt (DateTime)
- updatedAt (DateTime)
```

## 🔧 Environment Variables

### Backend (.env)
```env
DATABASE_URL="postgresql://user:password@localhost:5432/task_manager"
JWT_SECRET="your-super-secret-jwt-key"
NODE_ENV="development"
PORT=5000
```

### Frontend (.env)
```env
VITE_API_URL=http://localhost:5000/api/v1
```

## 📦 Build & Deployment

### Build Backend
```bash
cd backend
npm run build
npm start
```

### Build Frontend
```bash
cd frontend
npm run build
npm run preview
```

### Deploy to Render

1. Push to GitHub
2. Create new Web Service on Render
3. Connect repository
4. Set environment variables
5. Deploy

### Deploy to Vercel (Frontend)

1. Push to GitHub
2. Connect repository to Vercel
3. Set environment variables
4. Deploy

## 🧪 Testing

### Test Backend API

```bash
# Get all tasks
curl -X GET http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Create task
curl -X POST http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Task",
    "description": "Task description"
  }'
```

### Test Frontend

1. Open `http://localhost:3000`
2. Register a new account
3. Create, update, and delete tasks
4. Test logout and login

## 📈 Scalability Features

- ✅ API versioning (`/api/v1/`)
- ✅ JWT authentication
- ✅ Role-based access control
- ✅ Database indexing
- ✅ Error handling
- ✅ Input validation
- ✅ CORS enabled
- ✅ Docker support

### Future Improvements

- Redis caching
- Message queues (BullMQ)
- Microservices architecture
- Load balancing
- Kubernetes deployment
- CI/CD pipeline
- Rate limiting
- Helmet.js security headers
- Database connection pooling

## 🔒 Security

- ✅ JWT token-based auth
- ✅ Password hashing with bcryptjs
- ✅ CORS protection
- ✅ Input validation
- ✅ Role-based authorization
- ✅ Environment variables for secrets
- ✅ Error handling without exposing sensitive info

## 📝 Documentation

- **Backend**: See `backend/README.md`
- **Frontend**: See `frontend/README.md`
- **API Docs**: Available at `/api-docs` when backend is running

## 🐛 Troubleshooting

### Database Connection Error
- Ensure PostgreSQL is running
- Check DATABASE_URL in .env
- Run migrations: `npm run prisma:migrate`

### API Connection Error
- Ensure backend is running on port 5000
- Check VITE_API_URL in frontend .env
- Verify CORS is enabled

### Build Errors
- Clear node_modules: `rm -rf node_modules`
- Reinstall: `npm install`
- Clear cache: `rm -rf dist`

## 📞 Support

For issues or questions:
1. Check the README files in backend/ and frontend/
2. Review API documentation at `/api-docs`
3. Check error messages in console

## 📄 License

MIT

## 🎓 Learning Resources

- [Express.js Documentation](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Prisma Documentation](https://www.prisma.io/docs/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [JWT.io](https://jwt.io/)

---

**Built with ❤️ for scalability and production-readiness**

**Happy coding! 🚀**
