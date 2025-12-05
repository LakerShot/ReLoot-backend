#!/bin/bash

# ReLoot Backend Setup Script
# Этот скрипт автоматизирует начальную настройку проекта

set -e

echo "🚀 Starting ReLoot Backend setup..."
echo ""

# Check Node.js version
echo "📦 Checking Node.js version..."
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "❌ Error: Node.js 20+ is required (current: $(node -v))"
    exit 1
fi
echo "✅ Node.js version: $(node -v)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install
echo "✅ Dependencies installed"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚙️  Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please update .env with your configuration (especially JWT_SECRET for production)"
else
    echo "✅ .env file already exists"
fi
echo ""

# Start PostgreSQL
echo "🐳 Starting PostgreSQL with Docker..."
docker-compose -f docker-compose.dev.yml up -d
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5
echo "✅ PostgreSQL started"
echo ""

# Generate Prisma Client
echo "🔧 Generating Prisma Client..."
npx prisma generate
echo "✅ Prisma Client generated"
echo ""

# Run migrations
echo "📊 Running database migrations..."
npx prisma migrate deploy
echo "✅ Migrations completed"
echo ""

echo "🎉 Setup completed successfully!"
echo ""
echo "📚 Next steps:"
echo "  1. Review and update .env file (especially JWT_SECRET for production)"
echo "  2. Start the development server: npm run start:dev"
echo "  3. Open Swagger UI: http://localhost:3000/api/docs"
echo "  4. Open Prisma Studio: npx prisma studio"
echo ""
echo "Happy coding! 🚀"