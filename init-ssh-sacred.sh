#!/bin/bash

echo "🔐 GÉNÉRATION SACRÉE DE CLÉ SSH POUR GITHUB"

# 1. Vérifie si une clé existe déjà
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "✅ Une clé SSH existe déjà : ~/.ssh/id_ed25519"
else
    echo "🛠️ Génération d'une nouvelle clé SSH..."
    ssh-keygen -t ed25519 -C "DOMINUS-SILENS" -f ~/.ssh/id_ed25519 -N ""
fi

# 2. Lance l'agent SSH et ajoute la clé
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Configure ssh config propre
echo "📁 Configuration de ~/.ssh/config"
mkdir -p ~/.ssh
cat <<EOF > ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config

# 4. Affiche la clé publique à copier dans GitHub
echo
echo "📋 COPIE LA CLÉ CI-DESSOUS DANS GITHUB > SETTINGS > SSH KEYS"
echo "──────────────────────────────────────────────────────────────"
cat ~/.ssh/id_ed25519.pub
echo "──────────────────────────────────────────────────────────────"
echo "🔗 Ajoute-la ici : https://github.com/settings/ssh/new"
echo

# 5. Teste la connexion
read -p "⏳ Appuie sur Entrée une fois la clé ajoutée à GitHub..."

echo "🔁 Test de connexion à GitHub via SSH..."
ssh -T git@github.com

