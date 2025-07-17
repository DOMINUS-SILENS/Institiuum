#!/bin/bash

echo "🧼✨ SACRED CLEAN REBUILD : Recréation complète du SOCLE COMMERCIUM..."

# Étape 1 : Nettoyage sacré
./clean_apps.sh

# Étape 2 : Création des Dockerfiles sacrés
./sacred-create-dockerfiles.sh

# Étape 3 : Initialisation de l’API
./init_api_app.sh

# Étape 4 : Initialisation de l’interface ADMIN
./init_admin_app.sh

# Étape 5 : Initialisation de l’interface WEB
./init_web_app.sh

# Étape 6 : Lancement de l’ensemble avec Docker Compose
echo "🐳 Lancement sacré avec Docker Compose..."
docker compose up --build

