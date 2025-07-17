#!/bin/bash

echo "🔁 [SIFRĀN] Génération des form.config.json depuis les modèles FastAPI..."

SRC_DIR="apps/api/models"
DEST_DIR="apps/api/forms"

mkdir -p "$DEST_DIR"

for pyfile in "$SRC_DIR"/*.py; do
  model_name=$(basename "$pyfile" .py)
  echo "  🔧 Génération de $model_name..."

  # Appelle un script Python qui transforme le modèle en config JSON
  python3 scripts/utils/model_to_form_json.py "$pyfile" > "$DEST_DIR/$model_name.form.config.json"
done

echo "✅ Configurations de formulaires JSON générées dans $DEST_DIR."

