#!/bin/bash
set -o errexit

echo "🚀 Starting Heroku build process..."

# Build React frontend from source
echo "📦 Building React frontend..."
cd frontend
rm -rf dist
npm install
npm run build
cd ..

# Clean backend static directory
echo "🧹 Cleaning backend static..."
rm -rf backend/static/frontend/
mkdir -p backend/static/frontend

# Copy fresh build
echo "📁 Copying fresh React build to Django static..."
cp -r frontend/dist/* backend/static/frontend/

# Collect Django static files
echo "📊 Collecting Django static files..."
cd backend
python manage.py collectstatic --noinput
cd ..

echo "✅ Build complete!"
