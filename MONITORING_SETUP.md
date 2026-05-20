# Production Monitoring & Logging Setup

Complete guide to set up monitoring and logging for production.

## 📊 Monitoring Stack

### Backend Monitoring
- Error tracking: Sentry
- Performance: New Relic
- Uptime: UptimeRobot
- Logs: CloudWatch / Papertrail

### Frontend Monitoring
- Error tracking: Sentry
- Performance: LogRocket
- Analytics: Google Analytics
- Uptime: UptimeRobot

### Database Monitoring
- Performance: Render/Railway dashboard
- Backups: Automated
- Alerts: Email notifications

---

## 🚨 Step 1: Set Up Error Tracking with Sentry

### Backend Setup

1. Create Sentry account: https://sentry.io
2. Create new project (Node.js)
3. Install Sentry:

```bash
cd backend
npm install @sentry/node @sentry/tracing
```

4. Update `src/app.ts`:

```typescript
import * as Sentry from "@sentry/node";
import * as Tracing from "@sentry/tracing";

// Initialize Sentry
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
  integrations: [
    new Sentry.Integrations.Http({ tracing: true }),
    new Tracing.Express({ app: true }),
  ],
});

// Add Sentry middleware
app.use(Sentry.Handlers.requestHandler());
app.use(Sentry.Handlers.tracingHandler());

// ... your routes ...

// Error handler
app.use(Sentry.Handlers.errorHandler());
```

5. Add environment variable:
```env
SENTRY_DSN=your-sentry-dsn
```

### Frontend Setup

1. Install Sentry:

```bash
cd frontend
npm install @sentry/react @sentry/tracing
```

2. Update `src/main.tsx`:

```typescript
import * as Sentry from "@sentry/react";
import * as Tracing from "@sentry/tracing";

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  environment: import.meta.env.MODE,
  tracesSampleRate: 1.0,
  integrations: [
    new Sentry.Replay({
      maskAllText: true,
      blockAllMedia: true,
    }),
  ],
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
});

const App = Sentry.withProfiler(App);
```

3. Add environment variable:
```env
VITE_SENTRY_DSN=your-sentry-dsn
```

---

## 📈 Step 2: Set Up Performance Monitoring with New Relic

### Backend Setup

1. Create New Relic account: https://newrelic.com
2. Install New Relic:

```bash
cd backend
npm install newrelic
```

3. Create `newrelic.js`:

```javascript
exports.config = {
  app_name: ['Task Manager API'],
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  logging: {
    level: 'info'
  }
};
```

4. Update `src/server.ts` (first line):

```typescript
require('newrelic');
import app from './app';
```

5. Add environment variable:
```env
NEW_RELIC_LICENSE_KEY=your-license-key
```

---

## 📊 Step 3: Set Up Frontend Monitoring with LogRocket

### Frontend Setup

1. Create LogRocket account: https://logrocket.com
2. Install LogRocket:

```bash
cd frontend
npm install logrocket
```

3. Update `src/main.tsx`:

```typescript
import LogRocket from 'logrocket';

if (import.meta.env.PROD) {
  LogRocket.init('your-app-id');
}
```

4. Add environment variable:
```env
VITE_LOGROCKET_ID=your-app-id
```

---

## 🔔 Step 4: Set Up Uptime Monitoring

### UptimeRobot Setup

1. Create account: https://uptimerobot.com
2. Add new monitor:
   - **Type**: HTTP(s)
   - **URL**: https://your-backend-url/health
   - **Interval**: 5 minutes
   - **Alert contacts**: Your email

3. Add another monitor for frontend:
   - **Type**: HTTP(s)
   - **URL**: https://your-frontend-url
   - **Interval**: 5 minutes

---

## 📝 Step 5: Set Up Logging

### Backend Logging

Update `src/app.ts`:

```typescript
import morgan from 'morgan';

// Request logging
app.use(morgan('combined'));

// Custom logging
const logger = {
  info: (msg: string) => console.log(`[INFO] ${new Date().toISOString()} ${msg}`),
  error: (msg: string) => console.error(`[ERROR] ${new Date().toISOString()} ${msg}`),
  warn: (msg: string) => console.warn(`[WARN] ${new Date().toISOString()} ${msg}`),
};

export default logger;
```

### Frontend Logging

Create `src/utils/logger.ts`:

```typescript
const logger = {
  info: (msg: string, data?: any) => {
    console.log(`[INFO] ${msg}`, data);
  },
  error: (msg: string, error?: any) => {
    console.error(`[ERROR] ${msg}`, error);
  },
  warn: (msg: string, data?: any) => {
    console.warn(`[WARN] ${msg}`, data);
  },
};

export default logger;
```

---

## 📊 Step 6: Set Up Dashboards

### Sentry Dashboard

1. Go to Sentry project
2. View:
   - Error rates
   - Error trends
   - Top errors
   - Release tracking

### New Relic Dashboard

1. Go to New Relic
2. View:
   - Response times
   - Throughput
   - Error rates
   - Database performance

### LogRocket Dashboard

1. Go to LogRocket
2. View:
   - User sessions
   - Errors
   - Performance metrics
   - User interactions

---

## 🚨 Step 7: Set Up Alerts

### Sentry Alerts

1. Go to project settings
2. Create alert rule:
   - **Condition**: Error rate > 5%
   - **Action**: Send email
   - **Frequency**: Immediately

### New Relic Alerts

1. Go to Alerts & AI
2. Create policy:
   - **Condition**: Response time > 1s
   - **Notification**: Email
   - **Severity**: Critical

### UptimeRobot Alerts

1. Go to monitors
2. Set alert contacts:
   - Email
   - SMS
   - Slack
   - PagerDuty

---

## 📈 Step 8: Monitor Key Metrics

### Backend Metrics

- **Response Time**: < 200ms
- **Error Rate**: < 1%
- **Throughput**: > 100 req/s
- **Database Queries**: < 100ms
- **Memory Usage**: < 500MB
- **CPU Usage**: < 80%

### Frontend Metrics

- **Page Load Time**: < 3s
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Cumulative Layout Shift**: < 0.1
- **Error Rate**: < 0.1%

### Database Metrics

- **Connection Pool**: < 80% used
- **Query Time**: < 100ms
- **Slow Queries**: < 1%
- **Disk Usage**: < 80%
- **Backup Status**: Success

---

## 🔄 Step 9: Set Up Automated Backups

### Database Backups

**Render:**
1. Go to PostgreSQL service
2. Click "Settings"
3. Enable automated backups
4. Set retention: 30 days

**Railway:**
1. Go to PostgreSQL service
2. Click "Settings"
3. Enable backups
4. Set frequency: Daily

**AWS RDS:**
1. Go to RDS console
2. Select database
3. Set backup retention: 30 days
4. Enable automated backups

### Application Backups

```bash
# Backup database
pg_dump $DATABASE_URL > backup.sql

# Backup to S3
aws s3 cp backup.sql s3://your-bucket/backups/
```

---

## 📊 Step 10: Create Monitoring Dashboard

### Grafana Dashboard

1. Create Grafana account: https://grafana.com
2. Add data sources:
   - Prometheus
   - CloudWatch
   - New Relic
3. Create dashboard with:
   - Response times
   - Error rates
   - Database performance
   - User metrics

---

## 🎯 Monitoring Checklist

- [ ] Sentry configured for errors
- [ ] New Relic configured for performance
- [ ] LogRocket configured for frontend
- [ ] UptimeRobot monitoring endpoints
- [ ] Email alerts configured
- [ ] Slack integration enabled
- [ ] Dashboard created
- [ ] Backup strategy defined
- [ ] Retention policies set
- [ ] Team trained on monitoring

---

## 📞 Support

- **Sentry**: https://sentry.io/support
- **New Relic**: https://newrelic.com/support
- **LogRocket**: https://logrocket.com/support
- **UptimeRobot**: https://uptimerobot.com/support

---

**Your production monitoring is now set up! 🚀**
