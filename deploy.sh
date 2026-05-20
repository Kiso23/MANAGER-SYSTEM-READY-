#!/bin/bash

# Task Manager - Production Deployment Script
# This script helps deploy the application to production

set -e

echo "================================"
echo "Task Manager - Production Deploy"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if git is clean
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: Uncommitted changes detected${NC}"
    echo "Please commit or stash your changes before deploying"
    exit 1
fi

# Get deployment target
echo "Select deployment target:"
echo "1) Render"
echo "2) Railway"
echo "3) Heroku"
echo "4) Manual (Docker)"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo -e "${YELLOW}Deploying to Render...${NC}"
        echo ""
        echo "Steps:"
        echo "1. Go to https://render.com"
        echo "2. Create new Web Service for backend"
        echo "3. Create new PostgreSQL database"
        echo "4. Create new Static Site for frontend"
        echo "5. Set environment variables"
        echo ""
        echo "Backend environment variables:"
        echo "  DATABASE_URL=postgresql://..."
        echo "  JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")"
        echo "  NODE_ENV=production"
        echo ""
        echo "Frontend environment variables:"
        echo "  VITE_API_URL=https://your-backend-url/api/v1"
        echo ""
        ;;
    2)
        echo -e "${YELLOW}Deploying to Railway...${NC}"
        echo ""
        echo "Steps:"
        echo "1. Go to https://railway.app"
        echo "2. Create new project"
        echo "3. Add PostgreSQL service"
        echo "4. Add backend service (GitHub repo)"
        echo "5. Add frontend service (GitHub repo)"
        echo "6. Set environment variables"
        echo ""
        ;;
    3)
        echo -e "${YELLOW}Deploying to Heroku...${NC}"
        echo ""
        
        # Check if Heroku CLI is installed
        if ! command -v heroku &> /dev/null; then
            echo -e "${RED}Heroku CLI not found. Install from: https://devcenter.heroku.com/articles/heroku-cli${NC}"
            exit 1
        fi
        
        # Login to Heroku
        echo "Logging in to Heroku..."
        heroku login
        
        # Create apps
        read -p "Enter backend app name (e.g., task-manager-api): " backend_app
        read -p "Enter frontend app name (e.g., task-manager-ui): " frontend_app
        
        echo -e "${YELLOW}Creating Heroku apps...${NC}"
        heroku create $backend_app || true
        heroku create $frontend_app || true
        
        # Create database
        echo -e "${YELLOW}Creating PostgreSQL database...${NC}"
        heroku addons:create heroku-postgresql:hobby-dev -a $backend_app || true
        
        # Set environment variables
        echo -e "${YELLOW}Setting environment variables...${NC}"
        JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
        heroku config:set JWT_SECRET="$JWT_SECRET" -a $backend_app
        heroku config:set NODE_ENV="production" -a $backend_app
        
        # Deploy backend
        echo -e "${YELLOW}Deploying backend...${NC}"
        cd backend
        git push heroku main
        cd ..
        
        # Deploy frontend
        echo -e "${YELLOW}Deploying frontend...${NC}"
        cd frontend
        git push heroku main
        cd ..
        
        echo -e "${GREEN}Deployment complete!${NC}"
        echo ""
        echo "Backend URL: https://$backend_app.herokuapp.com"
        echo "Frontend URL: https://$frontend_app.herokuapp.com"
        echo ""
        ;;
    4)
        echo -e "${YELLOW}Manual Docker Deployment${NC}"
        echo ""
        echo "Steps:"
        echo "1. Build Docker images:"
        echo "   docker build -t task-manager-backend ./backend"
        echo "   docker build -t task-manager-frontend ./frontend"
        echo ""
        echo "2. Push to Docker Hub:"
        echo "   docker tag task-manager-backend your-username/task-manager-backend"
        echo "   docker push your-username/task-manager-backend"
        echo ""
        echo "3. Deploy to your server:"
        echo "   docker-compose -f docker-compose.prod.yml up -d"
        echo ""
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Deployment guide complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Follow the platform-specific instructions above"
echo "2. Set all environment variables"
echo "3. Run database migrations"
echo "4. Test the application"
echo "5. Monitor logs and metrics"
echo ""
echo "For more details, see PRODUCTION_DEPLOYMENT.md"
