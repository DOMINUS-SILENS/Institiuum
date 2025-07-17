#!/bin/bash

echo "🌐 Lancement du cycle sacré de synchronisation JSON ↔︎ TypeScript ↔︎ FastAPI"
echo "═════════════════════════════════════════════════════════════"

### 1. 🔁 Pydantic → form.config.json
echo "🔁 Génération des fichiers form.config.json depuis Pydantic..."
FORM_DIR="apps/admin/src/forms"
API_ROUTES_DIR="apps/api/routes"
mkdir -p "$FORM_DIR"

find apps/api/routes -name "*.py" | while read file; do
  MODEL_NAME=$(grep -E "class .*?\(BaseModel\)" "$file" | sed -E 's/class ([^(]+).*/\1/' | head -n1)

  if [ -n "$MODEL_NAME" ]; then
    CONFIG_PATH="$FORM_DIR/${MODEL_NAME,,}.form.config.json"
    echo "  📄 Modèle détecté : $MODEL_NAME → $CONFIG_PATH"

    echo "{" > "$CONFIG_PATH"
    echo "  \"title\": \"$MODEL_NAME Form\"," >> "$CONFIG_PATH"
    echo "  \"type\": \"object\"," >> "$CONFIG_PATH"
    echo "  \"properties\": {" >> "$CONFIG_PATH"

    grep -A20 "class $MODEL_NAME(BaseModel):" "$file" | \
      grep -v "class" | \
      grep ":" | \
      sed 's/#.*//' | sed 's/ //g' | sed '/^$/d' | \
      while IFS=: read field type; do
        echo "    \"$field\": { \"type\": \"$(echo "$type" | sed 's/int/integer/; s/str/string/; s/float/number/; s/bool/boolean/; s/.*\|.*//')\" }," >> "$CONFIG_PATH"
      done

    sed -i '$ s/,$//' "$CONFIG_PATH"
    echo "  }" >> "$CONFIG_PATH"
    echo "}" >> "$CONFIG_PATH"

    echo "✅ $CONFIG_PATH généré"
  fi
done

### 2. 🔄 form.config.json → model.ts
echo "🔄 Génération des fichiers model.ts TypeScript depuis form.config.json..."
MODELS_DIR="apps/admin/src/models"
mkdir -p "$MODELS_DIR"

for json_file in "$FORM_DIR"/*.form.config.json; do
  [ -f "$json_file" ] || continue

  base=$(basename "$json_file")
  name="${base%.form.config.json}"
  output_file="$MODELS_DIR/${name}.model.ts"

  echo "// 🔁 Généré depuis $base" > "$output_file"
  echo "export interface ${name^} {" >> "$output_file"

  grep -A100 '"properties": {' "$json_file" | \
    sed -n '/"properties": {/,/}/p' | \
    grep ':' | sed 's/[",]//g' | sed 's/^[ ]*//' | \
    grep -v '{' | grep -v '}' | while read -r line; do
      field=$(echo "$line" | cut -d: -f1)
      type=$(echo "$line" | cut -d: -f2 | sed 's/ //g')

      case $type in
        integer) ts_type="number" ;;
        number)  ts_type="number" ;;
        string)  ts_type="string" ;;
        boolean) ts_type="boolean" ;;
        *)       ts_type="any" ;;
      esac

      echo "  $field: $ts_type;" >> "$output_file"
  done

  echo "}" >> "$output_file"
  echo "✅ $output_file généré"
done

### 3. ⚙️ form.config.json → endpoints FastAPI
echo "⚙️ Génération des endpoints FastAPI depuis form.config.json..."
mkdir -p "$API_ROUTES_DIR"

for form_path in "$FORM_DIR"/*.form.config.json; do
  [ -f "$form_path" ] || continue

  base=$(basename "$form_path")
  name="${base%.form.config.json}"
  route_file="$API_ROUTES_DIR/${name}.py"
  class_name="${name^}"

  echo "📜 Création : $route_file"

  echo "from fastapi import APIRouter" > "$route_file"
  echo "from pydantic import BaseModel" >> "$route_file"
  echo "from typing import List, Optional" >> "$route_file"
  echo "" >> "$route_file"
  echo "router = APIRouter(" >> "$route_file"
  echo "    prefix=\"/${name}\"," >> "$route_file"
  echo "    tags=[\"${class_name}s\"]" >> "$route_file"
  echo ")" >> "$route_file"
  echo "" >> "$route_file"
  echo "class ${class_name}(BaseModel):" >> "$route_file"

  grep -A100 '"properties": {' "$form_path" | \
    sed -n '/"properties": {/,/}/p' | \
    grep ':' | sed 's/[",]//g' | sed 's/^[ ]*//' | \
    grep -v '{' | grep -v '}' | while read -r line; do
      field=$(echo "$line" | cut -d: -f1)
      type=$(echo "$line" | cut -d: -f2 | sed 's/ //g')

      case $type in
        integer) py_type="int" ;;
        number)  py_type="float" ;;
        string)  py_type="str" ;;
        boolean) py_type="bool" ;;
        *)       py_type="Any" ;;
      esac

      echo "    $field: $py_type" >> "$route_file"
  done

  echo "" >> "$route_file"
  echo "@router.post(\"/\")" >> "$route_file"
  echo "def create_${name}(item: ${class_name}):" >> "$route_file"
  echo "    return {\"message\": \"${class_name} created\", \"data\": item}" >> "$route_file"
  echo "" >> "$route_file"
  echo "@router.get(\"/\", response_model=List[${class_name}])" >> "$route_file"
  echo "def list_${name}s():" >> "$route_file"
  echo "    return []" >> "$route_file"

  echo "✅ Endpoint : $route_file"
done

echo "✨ Cycle sacré de génération terminé."
