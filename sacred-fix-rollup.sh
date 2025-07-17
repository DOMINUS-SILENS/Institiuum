#!/bin/bash

echo "🛠️ SACRED ROLLUP FIX - Purification de rollup et des node_modules..."

for dir in apps/web apps/admin; do
  echo "📦 Purge de $dir ..."
  rm -rf "$dir/node_modules" "$dir/package-lock.json"
  echo "📦 Réinstallation propre..."
  cd "$dir" && npm install && cd -
done

echo "✅ ROLLUP FIX TERMINÉ :: tout est purifié."
echo "🌀 Rebuild Docker conseillé :"
echo "   docker compose build --no-cache && docker compose up -d"

