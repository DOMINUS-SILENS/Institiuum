import os
import json

CONFIG_DIR = "apps/admin/src/config"
OUTPUT_DIR = "apps/api/models/generated"

os.makedirs(OUTPUT_DIR, exist_ok=True)

TYPE_MAP = {
    "text": "str",
    "number": "float",
    "checkbox": "bool",
    "datepicker": "date"
}

for filename in os.listdir(CONFIG_DIR):
    if filename.endswith(".config.json"):
        with open(os.path.join(CONFIG_DIR, filename)) as f:
            config = json.load(f)

        class_name = config.get("title", filename.replace(".config.json", "").capitalize())
        fields = config.get("fields", [])

        lines = [
            "from pydantic import BaseModel",
            "from datetime import date\n",
            f"class {class_name}(BaseModel):"
        ]

        for field in fields:
            name = field["name"]
            ftype = TYPE_MAP.get(field["type"], "str")
            lines.append(f"    {name}: {ftype}")

        model_path = os.path.join(OUTPUT_DIR, f"{class_name.lower()}.py")
        with open(model_path, "w") as f:
            f.write("\n".join(lines))

        print(f"✅ Modèle généré : {model_path}")
