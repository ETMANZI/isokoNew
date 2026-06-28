#!/bin/bash
set -o errexit

echo "🚀 Starting Heroku build process..."

echo "📦 Building React frontend..."
cd frontend
npm install
npm run build
cd ..

echo "📁 Copying React build to Django static..."
mkdir -p backend/static/frontend
cp -r frontend/dist/* backend/static/frontend/

echo "📊 Collecting Django static files..."
cd backend
python manage.py collectstatic --noinput
cd ..

echo "✅ Build complete!"
