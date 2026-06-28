#!/bin/bash
set -o errexit

echo "🚀 Starting fresh build..."

# Force clean frontend
echo "🧹 Cleaning frontend..."
cd frontend
rm -rf node_modules/.vite
rm -rf dist
npm install
npm run build
cd ..

# Clean backend static
echo "🧹 Cleaning backend static..."
rm -rf backend/static/frontend
mkdir -p backend/static/frontend

# Copy fresh build
echo "📁 Copying fresh build..."
cp -r frontend/dist/* backend/static/frontend/

# Auto-update template with new file names
echo "🔄 Updating template..."
cd backend/templates
NEW_JS=$(ls -1 ../static/frontend/assets/index-*.js 2>/dev/null | xargs -n1 basename | head -1)
NEW_CSS=$(ls -1 ../static/frontend/assets/index-*.css 2>/dev/null | xargs -n1 basename | head -1)

if [ -n "$NEW_JS" ] && [ -n "$NEW_CSS" ]; then
    sed -i "s|assets/index-[^']*\.js|assets/$NEW_JS|g" index.html
    sed -i "s|assets/index-[^']*\.css|assets/$NEW_CSS|g" index.html
    echo "✅ Template updated: JS=$NEW_JS, CSS=$NEW_CSS"
fi
cd ../..

# Collect static files - USE python3 NOT python
echo "📊 Collecting static files..."
cd backend
python3 manage.py collectstatic --noinput --clear
cd ..

echo "✅ Build complete!"
