# Database Configuration Guide

Complete guide to get DATABASE_URL from each hosting platform.

## 📊 DATABASE_URL Format

```
postgresql://username:password@host:port/database_name
```

**Example**:
```
postgresql://taskuser:mypassword123@db.example.com:5432/task_manager
```

**Components**:
- `postgresql://` - Protocol
- `taskuser` - Database username
- `mypassword123` - Database password
- `db.example.com` - Database host
- `5432` - Database port (default for PostgreSQL)
- `task_manager` - Database name

---

## 🚀 RENDER - Get DATABASE_URL

### Step 1: Create PostgreSQL Database

1. Go to https://render.com dashboard
2. Click "New +"
3. Select "PostgreSQL"
4. Configure:
   - **Name**: `task-manager-db`
   - **Database**: `task_manager`
   - **User**: `taskuser`
   - **Region**: Choose closest to you
   - **Plan**: Free (or Starter)
5. Click "Create Database"
6. Wait 2-3 minutes for database to be created

### Step 2: Get Connection String

1. Go to your PostgreSQL service
2. Click "Info" tab
3. Look for "Internal Database URL" or "External Database URL"
4. Copy the full connection string

**Example Render DATABASE_URL**:
```
postgresql://taskuser:abc123def456@dpg-abc123.render.com:5432/task_manager
```

### Step 3: Add to Backend Service

1. Go to your backend service
2. Click "Environment" tab
3. Click "Add Environment Variable"
4. **Key**: `DATABASE_URL`
5. **Value**: Paste the connection string
6. Click "Save"
7. Service automatically redeploys

---

## 🚀 RAILWAY - Get DATABASE_URL

### Step 1: Create PostgreSQL Database

1. Go to https://railway.app dashboard
2. Click "New Project"
3. Select "Provision PostgreSQL"
4. Railway automatically creates PostgreSQL

### Step 2: Get Connection String

1. Click on PostgreSQL service
2. Click "Variables" tab
3. Look for `DATABASE_URL` variable
4. Copy the value

**Example Railway DATABASE_URL**:
```
postgresql://postgres:password@containers.railway.app:5432/railway
```

### Step 3: Add to Backend Service

1. Go to backend service
2. Click "Variables" tab
3. Railway auto-generates DATABASE_URL from PostgreSQL
4. It's already connected!

**Note**: Railway automatically links PostgreSQL to your backend service.

---

## 🚀 HEROKU - Get DATABASE_URL

### Step 1: Create PostgreSQL Database

```bash
# Create Heroku app
heroku create task-manager-api

# Add PostgreSQL add-on
heroku addons:create heroku-postgresql:hobby-dev -a task-manager-api
```

### Step 2: Get Connection String

```bash
# View all config variables
heroku config -a task-manager-api

# Or get just DATABASE_URL
heroku config:get DATABASE_URL -a task-manager-api
```

**Example Heroku DATABASE_URL**:
```
postgresql://user123:password456@ec2-12-34-56-78.compute-1.amazonaws.com:5432/database_name
```

### Step 3: Verify Connection

```bash
# Test connection
psql "your-database-url"

# Or use Heroku CLI
heroku pg:info -a task-manager-api
```

---

## 🚀 AWS RDS - Get DATABASE_URL

### Step 1: Create RDS Database

1. Go to AWS Console
2. Search for "RDS"
3. Click "Create database"
4. Configure:
   - **Engine**: PostgreSQL
   - **Version**: 15.x
   - **DB instance identifier**: `task-manager-db`
   - **Master username**: `taskuser`
   - **Master password**: Generate strong password
   - **DB name**: `task_manager`
   - **Publicly accessible**: Yes (for testing)
5. Click "Create database"
6. Wait 5-10 minutes for database to be created

### Step 2: Get Connection Details

1. Go to RDS Dashboard
2. Click on your database instance
3. Look for "Connectivity & security" section
4. Find:
   - **Endpoint**: `task-manager-db.abc123.us-east-1.rds.amazonaws.com`
   - **Port**: `5432`
   - **DB name**: `task_manager`
   - **Master username**: `taskuser`

### Step 3: Build DATABASE_URL

```
postgresql://taskuser:your-password@task-manager-db.abc123.us-east-1.rds.amazonaws.com:5432/task_manager
```

### Step 4: Add to EC2 Environment

```bash
# SSH into EC2 instance
ssh -i your-key.pem ec2-user@your-instance-ip

# Set environment variable
export DATABASE_URL="postgresql://taskuser:password@host:5432/task_manager"

# Or add to .env file
echo 'DATABASE_URL="postgresql://taskuser:password@host:5432/task_manager"' >> .env
```

---

## 🚀 DIGITALOCEAN - Get DATABASE_URL

### Step 1: Create Managed Database

1. Go to DigitalOcean Console
2. Click "Databases"
3. Click "Create Database Cluster"
4. Configure:
   - **Engine**: PostgreSQL
   - **Version**: 15
   - **Cluster name**: `task-manager-db`
   - **Region**: Choose closest
   - **Size**: Basic ($15/month)
5. Click "Create Database Cluster"
6. Wait 5-10 minutes

### Step 2: Get Connection String

1. Go to your database cluster
2. Click "Connection Details"
3. Look for "Connection string"
4. Copy the full connection string

**Example DigitalOcean DATABASE_URL**:
```
postgresql://doadmin:password@db-postgresql-nyc1-12345.ondigitalocean.com:25060/defaultdb?sslmode=require
```

### Step 3: Add to App

```bash
# Add to environment
export DATABASE_URL="postgresql://doadmin:password@db-postgresql-nyc1-12345.ondigitalocean.com:25060/defaultdb?sslmode=require"
```

---

## 🚀 SUPABASE - Get DATABASE_URL

### Step 1: Create Supabase Project

1. Go to https://supabase.com
2. Click "New Project"
3. Configure:
   - **Project name**: `task-manager`
   - **Database password**: Generate strong password
   - **Region**: Choose closest
4. Click "Create new project"
5. Wait 2-3 minutes

### Step 2: Get Connection String

1. Go to your project
2. Click "Settings" → "Database"
3. Look for "Connection string"
4. Copy the PostgreSQL connection string

**Example Supabase DATABASE_URL**:
```
postgresql://postgres:password@db.abc123.supabase.co:5432/postgres
```

### Step 3: Add to App

```bash
export DATABASE_URL="postgresql://postgres:password@db.abc123.supabase.co:5432/postgres"
```

---

## 📋 DATABASE_URL Components Explained

### Format
```
postgresql://username:password@host:port/database
```

### Each Part

| Part | Example | Description |
|------|---------|-------------|
| Protocol | `postgresql://` | Database type |
| Username | `taskuser` | Database user |
| Password | `mypassword123` | Database password |
| Host | `db.example.com` | Database server address |
| Port | `5432` | Database port (default: 5432) |
| Database | `task_manager` | Database name |

### With SSL (Secure)
```
postgresql://username:password@host:port/database?sslmode=require
```

---

## 🔒 Security Tips

### Password Security

✅ **DO**:
- Use strong passwords (20+ characters)
- Use random generation: `crypto.randomBytes(16).toString('hex')`
- Store in environment variables
- Use different passwords for different environments

❌ **DON'T**:
- Use weak passwords
- Share passwords via email/chat
- Commit passwords to git
- Use same password everywhere

### Generate Strong Database Password

```bash
node -e "console.log(require('crypto').randomBytes(16).toString('hex'))"
```

Example output: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`

---

## 🧪 Test DATABASE_URL Connection

### Using psql (PostgreSQL CLI)

```bash
# Install PostgreSQL client
# macOS: brew install postgresql
# Ubuntu: sudo apt-get install postgresql-client
# Windows: Download from https://www.postgresql.org/download/windows/

# Test connection
psql "postgresql://username:password@host:5432/database"

# If successful, you'll see:
# psql (15.0)
# Type "help" for help.
# database=>
```

### Using Node.js

```bash
# Create test.js
cat > test.js << 'EOF'
const { Client } = require('pg');

const client = new Client({
  connectionString: process.env.DATABASE_URL
});

client.connect()
  .then(() => {
    console.log('✅ Database connection successful!');
    return client.query('SELECT NOW()');
  })
  .then(result => {
    console.log('Current time:', result.rows[0]);
    client.end();
  })
  .catch(err => {
    console.error('❌ Connection failed:', err.message);
    process.exit(1);
  });
EOF

# Run test
DATABASE_URL="your-connection-string" node test.js
```

### Using Prisma

```bash
# Test with Prisma
npx prisma db execute --stdin < /dev/null

# Or run migrations
npx prisma migrate deploy
```

---

## 🆘 Troubleshooting

### Connection Refused

**Error**: `connect ECONNREFUSED`

**Solutions**:
1. Check host is correct
2. Check port is correct (usually 5432)
3. Check database is running
4. Check firewall allows connection
5. Check credentials are correct

### Authentication Failed

**Error**: `password authentication failed`

**Solutions**:
1. Check username is correct
2. Check password is correct
3. Check special characters in password are URL-encoded
4. Reset password in platform dashboard

### Database Not Found

**Error**: `database "task_manager" does not exist`

**Solutions**:
1. Check database name is correct
2. Create database if it doesn't exist
3. Check you have permission to access database

### SSL Connection Error

**Error**: `SSL connection error`

**Solutions**:
1. Add `?sslmode=require` to connection string
2. Or add `?sslmode=disable` for testing only
3. Check SSL certificate is valid

### Connection String Format

**Wrong**:
```
postgresql://taskuser:password@host:5432/task_manager
```

**Right**:
```
postgresql://taskuser:password@host:5432/task_manager
```

**With special characters in password**:
```
postgresql://taskuser:pass%40word@host:5432/task_manager
```

---

## 📋 Platform Comparison

| Platform | Setup Time | Cost | Connection String |
|----------|-----------|------|-------------------|
| Render | 2-3 min | Free-$15/mo | Provided in dashboard |
| Railway | 1-2 min | $5-50/mo | Auto-generated |
| Heroku | 2-3 min | $9/mo | `heroku config:get` |
| AWS RDS | 5-10 min | $15-100/mo | Build from components |
| DigitalOcean | 5-10 min | $15/mo | Provided in dashboard |
| Supabase | 2-3 min | Free-$25/mo | Provided in dashboard |

---

## ✅ Checklist

Before deploying:
- [ ] DATABASE_URL obtained from platform
- [ ] Connection string tested locally
- [ ] Added to backend environment variables
- [ ] Database migrations run
- [ ] Can connect to database
- [ ] Database has correct schema
- [ ] Backups configured
- [ ] SSL enabled (if required)

---

## 📞 Support

### Render
- Docs: https://render.com/docs/databases
- Support: https://render.com/support

### Railway
- Docs: https://docs.railway.app/databases/postgresql
- Support: https://railway.app/support

### Heroku
- Docs: https://devcenter.heroku.com/articles/heroku-postgresql
- Support: https://help.heroku.com

### AWS RDS
- Docs: https://docs.aws.amazon.com/rds/
- Support: https://aws.amazon.com/support

### DigitalOcean
- Docs: https://docs.digitalocean.com/products/databases/
- Support: https://www.digitalocean.com/support

### Supabase
- Docs: https://supabase.com/docs
- Support: https://supabase.com/support

---

## 🎯 Next Steps

1. **Choose your platform** (Render recommended)
2. **Create PostgreSQL database**
3. **Get DATABASE_URL** from platform
4. **Test connection** locally
5. **Add to environment variables**
6. **Deploy application**

---

**Your database is ready! 🚀**
