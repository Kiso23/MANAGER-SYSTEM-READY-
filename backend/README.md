# Task Manager API - Backend

A scalable, production-ready task management system with Role-Based Access Control (RBAC), built with Node.js, Express, TypeScript, and PostgreSQL.

## 🎯 Features

- **User Authentication**: JWT-based authentication with bcrypt password hashing
- **Role-Based Access Control (RBAC)**: USER and ADMIN roles with different permissions
- **Task Management**: Full CRUD operations for tasks
- **Protected Routes**: All task endpoints require authentication
- **Admin Dashboard**: Admins can view and manage all tasks
- **User Dashboard**: Users can only manage their own tasks
- **API Versioning**: Organized under `/api/v1/` for scalability
- **Swagger Documentation**: Interactive API documentation at `/api-docs`
- **Error Handling**: Centralized error middleware with proper HTTP status codes
- **Input Validation**: Email, password, and task input validation
- **Security**: CORS enabled, environment variables for secrets

## 🛠️ Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: PostgreSQL
- **ORM**: Prisma
- **Authentication**: JWT + bcryptjs
- **Documentation**: Swagger/OpenAPI
- **Dev Tools**: ts-node-dev, TypeScript

## 📋 Prerequisites

- Node.js v18+ (v20+ recommended)
- PostgreSQL 12+
- npm or yarn

## 🚀 Installation & Setup

### 1. Clone and Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the root directory:

```env
DATABASE_URL="postgresql://user:password@localhost:5432/task_manager"
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"
NODE_ENV="development"
PORT=5000
```

### 3. Setup Database

```bash
# Run migrations
npm run prisma:migrate

# (Optional) Open Prisma Studio to view data
npm run prisma:studio
```

### 4. Start Development Server

```bash
npm run dev
```

Server will run on `http://localhost:5000`

## 📚 API Endpoints

### Authentication

#### Register User
```
POST /api/v1/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (201)**:
```json
{
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "USER"
  }
}
```

#### Login User
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200)**:
```json
{
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "USER"
  }
}
```

### Tasks

All task endpoints require authentication. Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

#### Get All Tasks
```
GET /api/v1/tasks
Authorization: Bearer <token>
```

**Response (200)**:
```json
{
  "tasks": [
    {
      "id": "uuid",
      "title": "Complete project",
      "description": "Finish the task manager",
      "completed": false,
      "userId": "uuid",
      "user": {
        "id": "uuid",
        "name": "John Doe",
        "email": "john@example.com"
      },
      "createdAt": "2026-05-20T10:00:00Z",
      "updatedAt": "2026-05-20T10:00:00Z"
    }
  ]
}
```

**Note**: Users see only their own tasks. Admins see all tasks.

#### Create Task
```
POST /api/v1/tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Complete project",
  "description": "Finish the task manager"
}
```

**Response (201)**:
```json
{
  "message": "Task created successfully",
  "task": {
    "id": "uuid",
    "title": "Complete project",
    "description": "Finish the task manager",
    "completed": false,
    "userId": "uuid",
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "createdAt": "2026-05-20T10:00:00Z",
    "updatedAt": "2026-05-20T10:00:00Z"
  }
}
```

#### Update Task
```
PUT /api/v1/tasks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated title",
  "description": "Updated description",
  "completed": true
}
```

**Response (200)**:
```json
{
  "message": "Task updated successfully",
  "task": { ... }
}
```

#### Delete Task
```
DELETE /api/v1/tasks/:id
Authorization: Bearer <token>
```

**Response (200)**:
```json
{
  "message": "Task deleted successfully"
}
```

## 🔐 Authentication & Authorization

### JWT Token Structure
```json
{
  "id": "user-uuid",
  "role": "USER" | "ADMIN",
  "iat": 1234567890,
  "exp": 1234654290
}
```

### Role Permissions

| Action | USER | ADMIN |
|--------|------|-------|
| View own tasks | ✅ | ✅ |
| View all tasks | ❌ | ✅ |
| Create tasks | ✅ | ✅ |
| Update own tasks | ✅ | ✅ |
| Update any task | ❌ | ✅ |
| Delete own tasks | ✅ | ✅ |
| Delete any task | ❌ | ✅ |

## 📊 Database Schema

### User Table
```sql
CREATE TABLE "User" (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  password VARCHAR NOT NULL,
  role ENUM('USER', 'ADMIN') DEFAULT 'USER',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Task Table
```sql
CREATE TABLE "Task" (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR NOT NULL,
  description VARCHAR,
  completed BOOLEAN DEFAULT false,
  userId UUID NOT NULL REFERENCES "User"(id) ON DELETE CASCADE,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🧪 Testing with cURL

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

### Get Tasks
```bash
curl -X GET http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Create Task
```bash
curl -X POST http://localhost:5000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Task",
    "description": "Task description"
  }'
```

## 📁 Project Structure

```
backend/
├── src/
│   ├── controllers/
│   │   ├── auth.controller.ts      # Authentication logic
│   │   └── task.controller.ts      # Task CRUD logic
│   ├── middleware/
│   │   ├── auth.middleware.ts      # JWT verification
│   │   ├── role.middleware.ts      # Role-based authorization
│   │   └── error.middleware.ts     # Error handling
│   ├── routes/
│   │   ├── auth.routes.ts          # Auth endpoints
│   │   └── task.routes.ts          # Task endpoints
│   ├── utils/
│   │   ├── jwt.ts                  # JWT utilities
│   │   └── validators.ts           # Input validation
│   ├── app.ts                      # Express app setup
│   └── server.ts                   # Server entry point
├── prisma/
│   └── schema.prisma               # Database schema
├── .env                            # Environment variables
├── package.json
├── tsconfig.json
└── README.md
```

## 🔧 Available Commands

```bash
# Development
npm run dev              # Start dev server with hot reload

# Build & Production
npm run build            # Compile TypeScript to JavaScript
npm start                # Run compiled JavaScript

# Database
npm run prisma:migrate   # Run database migrations
npm run prisma:generate  # Generate Prisma Client
npm run prisma:studio    # Open Prisma Studio GUI
```

## 🚀 Deployment

### Build for Production
```bash
npm run build
npm start
```

### Environment Variables for Production
```env
DATABASE_URL="postgresql://prod_user:prod_password@prod_host:5432/task_manager"
JWT_SECRET="use-a-strong-random-secret-key"
NODE_ENV="production"
PORT=5000
```

### Deploy to Render
1. Push code to GitHub
2. Connect repository to Render
3. Set environment variables in Render dashboard
4. Deploy

### Deploy to Railway
1. Push code to GitHub
2. Connect repository to Railway
3. Railway auto-detects Node.js
4. Set environment variables
5. Deploy

## 🔒 Security Features

- ✅ JWT-based authentication
- ✅ Password hashing with bcryptjs
- ✅ CORS enabled
- ✅ Input validation
- ✅ Role-based access control
- ✅ Environment variables for secrets
- ✅ Error handling without exposing sensitive info

## 📈 Scalability Improvements (Future)

- Microservices architecture
- Redis caching for frequently accessed data
- Load balancing with multiple instances
- Message queue system (BullMQ) for async tasks
- Horizontal scaling with Docker & Kubernetes
- API Gateway for routing
- CI/CD pipeline (GitHub Actions)
- Database connection pooling
- Rate limiting on endpoints
- Helmet.js for security headers

## 🐛 Error Codes

| Code | Message | Meaning |
|------|---------|---------|
| 400 | Bad Request | Invalid input or missing required fields |
| 401 | Unauthorized | Missing or invalid JWT token |
| 403 | Forbidden | Insufficient permissions for the action |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource already exists (e.g., duplicate email) |
| 500 | Internal Server Error | Server error |

## 📝 License

MIT

## 👨‍💻 Author

Built as a scalable, production-ready task management system.

---

**Happy coding! 🚀**
