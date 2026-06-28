#!/bin/bash
set -o errexit

echo "🚀 Building frontend..."
cd frontend
rm -rf node_modules/.vite dist
npm install
npm run build
cd ..

echo "📁 Copying build to Django static..."
rm -rf backend/static/frontend
mkdir -p backend/static/frontend
cp -r frontend/dist/* backend/static/frontend/

echo "🔄 Updating template with new file names..."
cd backend/templates
NEW_JS=$(ls -1 ../static/frontend/assets/index-*.js 2>/dev/null | xargs -n1 basename | head -1)
NEW_CSS=$(ls -1 ../static/frontend/assets/index-*.css 2>/dev/null | xargs -n1 basename | head -1)

if [ -n "$NEW_JS" ] && [ -n "$NEW_CSS" ]; then
    sed -i "s|assets/index-[^']*\.js|assets/$NEW_JS|g" index.html
    sed -i "s|assets/index-[^']*\.css|assets/$NEW_CSS|g" index.html
    echo "✅ Template updated: JS=$NEW_JS, CSS=$NEW_CSS"
fi
cd ../..

echo "✅ Frontend build complete - Python will handle collectstatic"
