#!/bin/bash
set -o errexit

echo "🚀 Starting Heroku build process..."

# Install frontend dependencies and build
echo "📦 Building React frontend..."
cd frontend
npm install
npm run build
cd ..

# Copy React build to Django's static directory
echo "📁 Copying React build to Django static..."
mkdir -p backend/static/frontend
cp -r frontend/dist/* backend/static/frontend/

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip install -r requirements.txt

# Collect Django static files
echo "📊 Collecting Django static files..."
cd backend
python manage.py collectstatic --noinput
cd ..

echo "✅ Build complete!"