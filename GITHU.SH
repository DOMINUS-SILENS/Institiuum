#!/bin/bash

# 🛡️ CONFIGURATION SACRÉE
GITHUB_USERNAME="DOMINUS-SILENS"
REPO_NAME="Institiuum"
GITHUB_SSH_URL="git@github.com:DOMINUS-SILENS/Institiuum.git"

# 📍 Emplacement du projet (répertoire courant)
PROJECT_DIR="$(pwd)"

echo "📦 Déploiement du projet depuis : $PROJECT_DIR"

# ⚙️ Étape 1 : initialisation Git (si nécessaire)
if [ ! -d ".git" ]; then
    echo "🌀 Initialisation du dépôt Git..."
    git init
    git branch -M main
fi

# 🔗 Étape 2 : configuration du remote (SSH)
if ! git remote | grep -q origin; then
    echo "🔗 Ajout du remote SSH : $GITHUB_SSH_URL"
    git remote add origin "$GITHUB_SSH_URL"
else
    echo "♻️ Remote déjà présent, mise à jour..."
    git remote set-url origin "$GITHUB_SSH_URL"
fi

# ➕ Étape 3 : ajouter tous les fichiers
git add .

# 📝 Étape 4 : message de commit
read -p "💬 Message du commit : " COMMIT_MSG
git commit -m "$COMMIT_MSG"

# 🚀 Étape 5 : push vers GitHub
echo "🚀 Poussée vers GitHub (SSH)..."
git push -u origin main

echo "✅ Push terminé avec succès."

