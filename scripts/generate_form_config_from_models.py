import inspect
import json
import os
from typing import get_args, get_origin
from pydantic import BaseModel
import importlib

# 🔁 Config sacré
TARGET_DIR = "apps/api/models"
OUTPUT_DIR = "apps/admin/src/config"

TYPE_MAP = {
    str: "text",
    int: "number",
    float: "number",
    bool: "checkbox",
}

def infer_field_type(field_type):
    if get_origin(field_type) is not None:
        origin = get_origin(field_type)
        args = get_args(field_type)
        if origin is list and args:
            return "select"  # ou "multi-select"
    if hasattr(field_type, "__name__") and field_type.__name__ == "date":
        return "datepicker"
    return TYPE_MAP.get(field_type, "text")

def generate_config(model_class, submit_url):
    fields = []
    for name, field in model_class.__annotations__.items():
        field_type = infer_field_type(field)
        fields.append({
            "name": name,
            "label": name.capitalize(),
            "type": field_type
        })

    config = {
        "title": model_class.__name__,
        "submitUrl": submit_url,
        "submitMethod": "POST",
        "fields": fields
    }

    output_file = os.path.join(OUTPUT_DIR, f"{model_class.__name__.lower()}.config.json")
    with open(output_file, "w") as f:
        json.dump(config, f, indent=2)
    print(f"✅ Config générée : {output_file}")

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # ⚠️ Adapter ce nom au nom de ton module
    module = importlib.import_module("apps.api.models.user_models")
    
    for name, obj in inspect.getmembers(module, inspect.isclass):
        if issubclass(obj, BaseModel) and obj.__module__.startswith("apps.api.models"):
            submit_url = f"/api/{name.lower()}"
            generate_config(obj, submit_url)

if __name__ == "__main__":
    main()
