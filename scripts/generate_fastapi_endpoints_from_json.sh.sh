#!/bin/bash

echo "⚙️ [AL-MUHAYMIN] Génération des endpoints FastAPI depuis les fichiers JSON..."

FORMS_DIR="apps/api/forms"
ROUTES_DIR="apps/api/routes"

mkdir -p "$ROUTES_DIR"

for file in "$FORMS_DIR"/*.json; do
  [ -e "$file" ] || continue

  filename=$(basename -- "$file")
  base="${filename%.json}"
  route_file="$ROUTES_DIR/${base}_route.py"

  echo "📡 Génération de $route_file..."

  python3 scripts/utils/form_json_to_fastapi_route.py "$file" > "$route_file"
done

echo "✅ Endpoints FastAPI générés à partir des fichiers JSON."

