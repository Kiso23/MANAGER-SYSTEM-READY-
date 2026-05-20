FROM node:18-alpine

WORKDIR /app

# Install OpenSSL for Prisma compatibility
RUN apk add --no-cache openssl

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build TypeScript
RUN npm run build

# Run Prisma migrations
RUN npx prisma migrate deploy

# Expose port
EXPOSE 5000

# Start server
CMD ["npm", "start"]
