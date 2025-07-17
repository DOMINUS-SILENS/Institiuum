#!/bin/bash

echo "🧬 [NOŪAH] Initialisation de l'API FastAPI..."

API_DIR="apps/api"

mkdir -p $API_DIR
cd $API_DIR || exit 1

# Création de main.py sacré
cat > main.py <<EOF
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Bienvenue dans l'API sacrée de COMMERCIUM."}
EOF

# Création de requirements.txt sacré
cat > requirements.txt <<EOF
fastapi
uvicorn[standard]
pydantic
EOF

echo "✅ API FastAPI initialisée dans $API_DIR"

