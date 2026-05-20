# Task Manager Frontend

A modern, responsive React + TypeScript + Tailwind CSS frontend for the Task Manager application.

## 🎯 Features

- **User Authentication**: Login and registration pages
- **Protected Routes**: Dashboard only accessible to authenticated users
- **Task Management**: Create, read, update, and delete tasks
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Role-Based UI**: Different views for USER and ADMIN roles
- **Real-time Updates**: Instant task list updates
- **Error Handling**: User-friendly error messages
- **JWT Token Management**: Automatic token handling and refresh

## 🛠️ Tech Stack

- **React 18**: UI library
- **TypeScript**: Type safety
- **Vite**: Fast build tool
- **Tailwind CSS**: Utility-first CSS framework
- **React Router**: Client-side routing
- **Axios**: HTTP client
- **Context API**: State management

## 📋 Prerequisites

- Node.js v18+ (v20+ recommended)
- npm or yarn

## 🚀 Installation & Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the root directory:

```env
VITE_API_URL=http://localhost:5000/api/v1
```

### 3. Start Development Server

```bash
npm run dev
```

Frontend will run on `http://localhost:3000`

## 📁 Project Structure

```
frontend/
├── src/
│   ├── components/
│   │   ├── Navbar.tsx           # Navigation bar
│   │   └── ProtectedRoute.tsx   # Route protection wrapper
│   ├── context/
│   │   └── AuthContext.tsx      # Authentication context
│   ├── pages/
│   │   ├── Home.tsx             # Landing page
│   │   ├── Login.tsx            # Login page
│   │   ├── Register.tsx         # Registration page
│   │   └── Dashboard.tsx        # Task dashboard
│   ├── services/
│   │   └── api.ts               # API client
│   ├── App.tsx                  # Main app component
│   ├── main.tsx                 # Entry point
│   └── index.css                # Global styles
├── index.html
├── vite.config.ts
├── tailwind.config.js
├── postcss.config.js
├── tsconfig.json
└── package.json
```

## 🔧 Available Commands

```bash
# Development
npm run dev              # Start dev server with hot reload

# Build & Production
npm run build            # Build for production
npm run preview          # Preview production build
```

## 🔐 Authentication Flow

1. User registers or logs in
2. Backend returns JWT token
3. Token stored in localStorage
4. Token automatically attached to all API requests
5. If token expires (401), user redirected to login

## 📄 Pages

### Home Page (`/`)
- Landing page with feature overview
- Links to login/register or dashboard

### Login Page (`/login`)
- Email and password input
- Error handling
- Link to registration page

### Register Page (`/register`)
- Name, email, password input
- Password confirmation
- Validation
- Link to login page

### Dashboard Page (`/dashboard`)
- Protected route (requires authentication)
- Task list with create/update/delete functionality
- Task completion toggle
- Admin view shows all tasks with creator info

## 🎨 Styling

Uses Tailwind CSS for styling. Key classes:

- `bg-blue-600`: Primary blue color
- `hover:bg-blue-700`: Hover state
- `rounded-lg`: Border radius
- `shadow-md`: Box shadow
- `px-4 py-2`: Padding

## 🔄 API Integration

All API calls go through `src/services/api.ts`:

```typescript
// Authentication
authAPI.register(data)
authAPI.login(data)

// Tasks
taskAPI.getTasks()
taskAPI.createTask(data)
taskAPI.updateTask(id, data)
taskAPI.deleteTask(id)
```

## 🚀 Deployment

### Build for Production

```bash
npm run build
```

This creates a `dist` folder with optimized production build.

### Deploy to Vercel

1. Push code to GitHub
2. Connect repository to Vercel
3. Set environment variables
4. Deploy

### Deploy to Netlify

1. Push code to GitHub
2. Connect repository to Netlify
3. Build command: `npm run build`
4. Publish directory: `dist`
5. Deploy

## 🔒 Security Features

- ✅ JWT token stored in localStorage
- ✅ Automatic token attachment to requests
- ✅ Protected routes with authentication check
- ✅ Automatic logout on 401 response
- ✅ Input validation
- ✅ CORS enabled on backend

## 🐛 Troubleshooting

### API Connection Issues

If frontend can't connect to backend:

1. Ensure backend is running on `http://localhost:5000`
2. Check `VITE_API_URL` in `.env`
3. Verify CORS is enabled on backend
4. Check browser console for errors

### Token Issues

If you're getting 401 errors:

1. Clear localStorage: `localStorage.clear()`
2. Log out and log back in
3. Check token expiration (7 days)

### Build Issues

If build fails:

1. Clear node_modules: `rm -rf node_modules`
2. Reinstall: `npm install`
3. Clear Vite cache: `rm -rf dist`
4. Rebuild: `npm run build`

## 📚 Component Documentation

### ProtectedRoute

Wraps routes that require authentication:

```tsx
<ProtectedRoute>
  <Dashboard />
</ProtectedRoute>
```

### useAuth Hook

Access authentication context:

```tsx
const { user, token, login, logout, isAuthenticated } = useAuth();
```

## 🎯 Future Enhancements

- Task filtering and sorting
- Task categories/tags
- Task due dates
- Task priority levels
- Task comments
- Real-time notifications
- Dark mode
- Mobile app (React Native)
- Offline support (PWA)

## 📝 License

MIT

---

**Happy coding! 🚀**
