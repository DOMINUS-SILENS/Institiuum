#!/bin/bash

echo "📜 SCRIBA MUNDI - Build Vivant du $(date '+%Y-%m-%d %H:%M')"
echo "══════════════════════════════════════════════════════════"

echo "🧹 Purge ancienne configuration..."
./sacred-clean-install.sh
./sacred-clean-rebuild.sh

echo "🧬 Initialisation des modules sacrés..."
./init_api_app.sh
./init_admin_app.sh
./init_web_app.sh

echo "🐳 Lancement sacré avec Docker Compose..."
docker compose build
docker compose up -d

echo "🔁 Lancement de la génération sacrée (JSON ↔︎ TS ↔︎ FastAPI)..."
./generate-sacred-all.sh

echo "🩺 Vérification sacrée des ports ouverts COMMERCIUM..."

check_url() {
  if curl -s --head "$1" | grep "200 OK" > /dev/null; then
    echo "✅ $2 joignable → $1"
  else
    echo "❌ $2 **n'est pas** joignable à $1"
  fi
}

check_url "http://localhost:5173" "ADMIN"
check_url "http://localhost:5174" "WEB"
check_url "http://localhost:8000" "API"

echo ""
echo "🌟 BUILD TERMINÉ : UNIVERS EMPORIUM PRÊT 🌐"
echo "🔗 Admin Panel     → http://localhost:5173/"
echo "🔗 Front Office    → http://localhost:5174/"
echo "📦 API FastAPI     → http://localhost:8000/docs"
echo "🧠 DB PostgreSQL   → localhost:5432"
echo "══════════════════════════════════════════════════════════"

