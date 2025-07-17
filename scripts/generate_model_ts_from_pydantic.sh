#!/bin/bash

echo "🔄 [RĀFID] Génération des modèles TypeScript depuis Pydantic..."

MODELS_DIR="apps/api/models"
OUTDIR_ADMIN="apps/admin/src/models"
OUTDIR_WEB="apps/web/src/models"

mkdir -p "$OUTDIR_ADMIN"
mkdir -p "$OUTDIR_WEB"

for model_file in "$MODELS_DIR"/*.py; do
  [ -e "$model_file" ] || continue

  filename=$(basename -- "$model_file")
  base="${filename%.py}"
  outfile="${base^}.ts"  # Capitalise première lettre

  echo "📦 Conversion $filename → $outfile"

  python3 scripts/utils/pydantic_to_ts.py "$model_file" > "$OUTDIR_ADMIN/$outfile"
  cp "$OUTDIR_ADMIN/$outfile" "$OUTDIR_WEB/$outfile"
done

echo "✅ Modèles TypeScript générés dans $OUTDIR_ADMIN et $OUTDIR_WEB"

