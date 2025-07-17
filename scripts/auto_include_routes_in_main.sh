#!/bin/bash

echo "🛡️ [AL-MUHAYMIN] Inclusion automatique des routes FastAPI dans main.py..."

ROUTES_DIR="apps/api/routes"
MAIN_FILE="apps/api/main.py"

# Préambule sacré
echo "from fastapi import FastAPI" > "$MAIN_FILE"

# Import dynamique de chaque router
for route_file in "$ROUTES_DIR"/*_route.py; do
  base=$(basename "$route_file" _route.py)
  echo "from routes import ${base}_route" >> "$MAIN_FILE"
done

# Création de l'app
echo -e "\napp = FastAPI()\n" >> "$MAIN_FILE"

# Inclusion dynamique
for route_file in "$ROUTES_DIR"/*_route.py; do
  base=$(basename "$route_file" _route.py)
  echo "app.include_router(${base}_route.router)" >> "$MAIN_FILE"
done

echo "✅ main.py régénéré avec tous les routers disponibles."

