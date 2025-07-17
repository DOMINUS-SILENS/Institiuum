#!/bin/bash

echo "⚙️ [AL-MUHAYMIN] Génération des endpoints FastAPI depuis les fichiers JSON..."

CONFIG_DIR="apps/api/forms"
ROUTES_DIR="apps/api/routes"
mkdir -p "$ROUTES_DIR"

for jsonfile in "$CONFIG_DIR"/*.json; do
  base=$(basename "$jsonfile" .form.config.json)
  echo "  📡 Endpoint pour $base..."

  # Appelle un script Python de génération de route
  python3 scripts/utils/form_json_to_fastapi_route.py "$jsonfile" > "$ROUTES_DIR/${base}_route.py"
done

echo "✅ Endpoints générés dans $ROUTES_DIR."

