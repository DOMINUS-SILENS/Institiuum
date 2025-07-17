#!/bin/bash

echo "🚀 Initialisation de l'application ADMIN..."

APP_PATH="apps/admin"

mkdir -p $APP_PATH/src

# --- Create package.json ---
cat > $APP_PATH/package.json << EOL
{
  "name": "admin",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.1",
    "vite": "^5.2.0"
  }
}
EOL

# --- Create vite.config.js ---
cat > $APP_PATH/vite.config.js << EOL
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173
  }
})
EOL

# --- Create index.html ---
cat > $APP_PATH/index.html << EOL
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Commercium Admin</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOL

# --- Create main.jsx ---
cat > $APP_PATH/src/main.jsx << EOL
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOL

# --- Create App.jsx ---
cat > $APP_PATH/src/App.jsx << EOL
function App() {
  return (
    <>
      <h1>Commercium Admin</h1>
      <p>Welcome to the administration dashboard.</p>
    </>
  )
}

export default App
EOL

# --- Create Production Dockerfile ---
cat > $APP_PATH/Dockerfile << EOL
# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM nginx:1.25-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOL

# --- Create Nginx Config ---
cat > $APP_PATH/nginx.conf << EOL
server {
    listen 80;
    server_name localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files \$uri /index.html;
    }

    # Prevent nginx from serving dotfiles (.git, .htaccess, etc.)
    location ~ /\. {
        deny all;
    }
}
EOL

echo "✅ Application ADMIN initialisée."


echo "🛠️ Initialisation de l’interface ADMIN avec Vite + React + ShadCN..."

ADMIN_DIR="apps/admin"
mkdir -p $ADMIN_DIR
cd $ADMIN_DIR || exit 1

# Initialisation du projet Vite
npm create vite@latest . -- --template react-ts

# Installation des dépendances de base
npm install

# Initialisation de Tailwind + ShadCN UI
npx shadcn-ui@latest init --tailwind

# Ajout des scripts essentiels au package.json
npx json -I -f package.json -e '
  this.scripts = {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  }
'

echo "✅ apps/admin prêt avec Vite, React, Tailwind et ShadCN UI."

