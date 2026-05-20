# Task Manager - Architecture Overview

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                             │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              React Frontend (Port 3000)                  │   │
│  │                                                          │   │
│  │  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │   │
│  │  │   Login     │  │  Register    │  │  Dashboard   │   │   │
│  │  │   Page      │  │  Page        │  │  Page        │   │   │
│  │  └─────────────┘  └──────────────┘  └──────────────┘   │   │
│  │         │                │                  │            │   │
│  │         └────────────────┼──────────────────┘            │   │
│  │                          │                               │   │
│  │                   ┌──────▼──────┐                        │   │
│  │                   │ Auth Context│                        │   │
│  │                   │ (JWT Token) │                        │   │
│  │                   └──────┬──────┘                        │   │
│  │                          │                               │   │
│  │                   ┌──────▼──────┐                        │   │
│  │                   │ Axios Client│                        │   │
│  │                   │ (API Calls) │                        │   │
│  │                   └──────┬──────┘                        │   │
│  └────────────────────────┼─────────────────────────────────┘   │
│                           │                                      │
└───────────────────────────┼──────────────────────────────────────┘
                            │
                    HTTP/HTTPS (REST API)
                            │
┌───────────────────────────┼──────────────────────────────────────┐
│                           │                                      │
│                    ┌──────▼──────┐                               │
│                    │   CORS      │                               │
│                    │  Middleware │                               │
│                    └──────┬──────┘                               │
│                           │                                      │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │         Express Backend (Port 5000)                      │   │
│  │                                                          │   │
│  │  ┌──────────────────────────────────────────────────┐   │   │
│  │  │              API Routes                          │   │   │
│  │  │                                                  │   │   │
│  │  │  POST   /api/v1/auth/register                   │   │   │
│  │  │  POST   /api/v1/auth/login                      │   │   │
│  │  │  GET    /api/v1/tasks                           │   │   │
│  │  │  POST   /api/v1/tasks                           │   │   │
│  │  │  PUT    /api/v1/tasks/:id                       │   │   │
│  │  │  DELETE /api/v1/tasks/:id                       │   │   │
│  │  └──────────────────────────────────────────────────┘   │   │
│  │                      │                                   │   │
│  │  ┌──────────────────▼──────────────────────────────┐   │   │
│  │  │         Auth Middleware                         │   │   │
│  │  │  - Verify JWT Token                            │   │   │
│  │  │  - Attach User to Request                      │   │   │
│  │  └──────────────────┬──────────────────────────────┘   │   │
│  │                     │                                   │   │
│  │  ┌──────────────────▼──────────────────────────────┐   │   │
│  │  │      Role Middleware                            │   │   │
│  │  │  - Check User Role (USER/ADMIN)                │   │   │
│  │  │  - Authorize Access                            │   │   │
│  │  └──────────────────┬──────────────────────────────┘   │   │
│  │                     │                                   │   │
│  │  ┌──────────────────▼──────────────────────────────┐   │   │
│  │  │      Controllers                                │   │   │
│  │  │  - auth.controller.ts                          │   │   │
│  │  │  - task.controller.ts                          │   │   │
│  │  └──────────────────┬──────────────────────────────┘   │   │
│  │                     │                                   │   │
│  │  ┌──────────────────▼──────────────────────────────┐   │   │
│  │  │      Services/Utils                             │   │   │
│  │  │  - JWT Token Generation                        │   │   │
│  │  │  - Password Hashing (bcryptjs)                 │   │   │
│  │  │  - Input Validation                            │   │   │
│  │  └──────────────────┬──────────────────────────────┘   │   │
│  │                     │                                   │   │
│  │  ┌──────────────────▼──────────────────────────────┐   │   │
│  │  │      Error Middleware                           │   │   │
│  │  │  - Catch Errors                                │   │   │
│  │  │  - Format Error Response                       │   │   │
│  │  └──────────────────┬──────────────────────────────┘   │   │
│  └────────────────────┼─────────────────────────────────────┘   │
│                       │                                         │
└───────────────────────┼─────────────────────────────────────────┘
                        │
                   SQL Queries
                        │
┌───────────────────────┼─────────────────────────────────────────┐
│                       │                                         │
│  ┌──────────────────▼──────────────────────────────────────┐   │
│  │         Prisma ORM                                      │   │
│  │  - Query Builder                                       │   │
│  │  - Type Safety                                         │   │
│  │  - Migrations                                          │   │
│  └──────────────────┬──────────────────────────────────────┘   │
│                     │                                           │
│  ┌──────────────────▼──────────────────────────────────────┐   │
│  │      PostgreSQL Database (Port 5432)                   │   │
│  │                                                        │   │
│  │  ┌────────────────────────────────────────────────┐   │   │
│  │  │  User Table                                    │   │   │
│  │  │  - id (UUID)                                  │   │   │
│  │  │  - name, email, password                      │   │   │
│  │  │  - role (USER/ADMIN)                          │   │   │
│  │  │  - timestamps                                 │   │   │
│  │  └────────────────────────────────────────────────┘   │   │
│  │                                                        │   │
│  │  ┌────────────────────────────────────────────────┐   │   │
│  │  │  Task Table                                    │   │   │
│  │  │  - id (UUID)                                  │   │   │
│  │  │  - title, description                         │   │   │
│  │  │  - completed (boolean)                        │   │   │
│  │  │  - userId (FK)                                │   │   │
│  │  │  - timestamps                                 │   │   │
│  │  └────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## �� Request Flow

### 1. User Registration

```
User Input (Register Form)
    ↓
Frontend: POST /api/v1/auth/register
    ↓
Backend: Validate Input
    ↓
Backend: Hash Password (bcryptjs)
    ↓
Backend: Create User in Database
    ↓
Backend: Generate JWT Token
    ↓
Response: Token + User Data
    ↓
Frontend: Store Token in localStorage
    ↓
Frontend: Redirect to Dashboard
```

### 2. User Login

```
User Input (Login Form)
    ↓
Frontend: POST /api/v1/auth/login
    ↓
Backend: Find User by Email
    ↓
Backend: Verify Password
    ↓
Backend: Generate JWT Token
    ↓
Response: Token + User Data
    ↓
Frontend: Store Token in localStorage
    ↓
Frontend: Redirect to Dashboard
```

### 3. Create Task

```
User Input (Task Form)
    ↓
Frontend: POST /api/v1/tasks
    ↓
Axios: Attach JWT Token to Header
    ↓
Backend: Auth Middleware - Verify Token
    ↓
Backend: Extract User ID from Token
    ↓
Backend: Validate Task Input
    ↓
Backend: Create Task in Database
    ↓
Response: Created Task
    ↓
Frontend: Update Task List
    ↓
Frontend: Display Success Message
```

### 4. Get Tasks

```
User Navigates to Dashboard
    ↓
Frontend: GET /api/v1/tasks
    ↓
Axios: Attach JWT Token to Header
    ↓
Backend: Auth Middleware - Verify Token
    ↓
Backend: Check User Role
    ↓
Backend: Query Tasks (USER sees own, ADMIN sees all)
    ↓
Response: Array of Tasks
    ↓
Frontend: Display Tasks in UI
```

## 🔐 Authentication Flow

```
┌─────────────────────────────────────────────────────────┐
│                   JWT Token Structure                    │
│                                                         │
│  Header:                                                │
│  {                                                      │
│    "alg": "HS256",                                      │
│    "typ": "JWT"                                         │
│  }                                                      │
│                                                         │
│  Payload:                                               │
│  {                                                      │
│    "id": "user-uuid",                                   │
│    "role": "USER" | "ADMIN",                            │
│    "iat": 1234567890,                                   │
│    "exp": 1234654290                                    │
│  }                                                      │
│                                                         │
│  Signature:                                             │
│  HMACSHA256(                                            │
│    base64UrlEncode(header) + "." +                      │
│    base64UrlEncode(payload),                            │
│    secret                                               │
│  )                                                      │
└─────────────────────────────────────────────────────────┘
```

## 📊 Data Flow Diagram

```
┌──────────────────────────────────────────────────────────┐
│                    Frontend State                         │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Auth Context                                      │ │
│  │  - user: User | null                              │ │
│  │  - token: string | null                           │ │
│  │  - isAuthenticated: boolean                       │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Component State                                   │ │
│  │  - tasks: Task[]                                  │ │
│  │  - loading: boolean                               │ │
│  │  - error: string | null                           │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
         ↓
┌──────────────────────────────────────────────────────────┐
│                    API Layer                             │
│                                                          │
│  Axios Instance with Interceptors                       │
│  - Request: Add JWT Token                               │
│  - Response: Handle 401 Errors                          │
└──────────────────────────────────────────────────────────┘
         ↓
┌──────────────────────────────────────────────────────────┐
│                    Backend API                           │
│                                                          │
│  Express Routes → Controllers → Services → Database     │
└──────────────────────────────────────────────────────────┘
         ↓
┌──────────────────────────────────────────────────────────┐
│                    Database                              │
│                                                          │
│  PostgreSQL with Prisma ORM                             │
│  - User Table                                           │
│  - Task Table                                           │
└──────────────────────────────────────────────────────────┘
```

## 🔒 Security Layers

```
Layer 1: CORS
├─ Restrict requests to allowed origins
└─ Prevent cross-site attacks

Layer 2: Input Validation
├─ Validate email format
├─ Validate password length
├─ Validate task input
└─ Prevent injection attacks

Layer 3: Authentication
├─ JWT token verification
├─ Token expiration (7 days)
└─ Secure token storage

Layer 4: Authorization
├─ Role-based access control
├─ User ownership verification
└─ Admin-only endpoints

Layer 5: Password Security
├─ bcryptjs hashing
├─ Salt rounds: 10
└─ Never store plain passwords

Layer 6: Error Handling
├─ Don't expose sensitive info
├─ Generic error messages
└─ Proper HTTP status codes
```

## 📦 Deployment Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Production                            │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Frontend (Vercel/Netlify)                       │  │
│  │  - React SPA                                     │  │
│  │  - CDN Distribution                              │  │
│  │  - Auto Scaling                                  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Backend (Render/Railway)                        │  │
│  │  - Node.js Server                                │  │
│  │  - Auto Scaling                                  │  │
│  │  - Health Checks                                 │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Database (Managed PostgreSQL)                   │  │
│  │  - Automated Backups                             │  │
│  │  - Replication                                   │  │
│  │  - SSL Encryption                                │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 🎯 Key Design Patterns

### 1. MVC Pattern (Backend)
- **Model**: Prisma schemas
- **View**: JSON responses
- **Controller**: Business logic

### 2. Context API (Frontend)
- Global state management
- Auth context for user data
- Avoid prop drilling

### 3. Middleware Pattern (Backend)
- Auth middleware
- Role middleware
- Error middleware

### 4. Protected Routes (Frontend)
- Check authentication
- Check authorization
- Redirect if unauthorized

### 5. Interceptors (Frontend)
- Auto-attach JWT token
- Handle 401 responses
- Centralized error handling

---

**This architecture is scalable, secure, and production-ready! 🚀**
