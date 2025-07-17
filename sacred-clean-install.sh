#!/bin/bash

echo "🧼✨ SACRED CLEAN INSTALL : Recréation Totale de COMMERCIUM..."

# 🔁 Arrêt et suppression des conteneurs Docker
echo "🔁 Arrêt et suppression des conteneurs..."
docker compose down -v --remove-orphans

# 🔥 Nettoyage complet des fichiers parasites
echo "🔥 Suppression des node_modules, dist, pycache, package-lock..."
find apps/ -type d -name "node_modules" -exec rm -rf {} +
find apps/ -type d -name "__pycache__" -exec rm -rf {} +
find apps/ -type d -name "dist" -exec rm -rf {} +
find apps/ -type f -name "package-lock.json" -delete
find apps/ -type f -name "yarn.lock" -delete
find apps/ -type f -name "*.db" -delete
rm -rf apps/api/__pycache__
rm -rf apps/api/.mypy_cache
rm -rf apps/api/.pytest_cache

# 🛠️ Suppression des Dockerfile obsolètes
echo "🛠️ Suppression des Dockerfile obsolètes..."
rm -f apps/api/Dockerfile
rm -f apps/admin/Dockerfile
rm -f apps/web/Dockerfile

# 🌱 Recréation des dossiers apps/
echo "🌱 Recréation des dossiers apps/..."
rm -rf apps/api apps/admin apps/web
mkdir -p apps/api/forms apps/api/models apps/api/routes
mkdir -p apps/admin/src/models
mkdir -p apps/web/src/models

echo "✅ CLEAN INSTALL TERMINÉE."

