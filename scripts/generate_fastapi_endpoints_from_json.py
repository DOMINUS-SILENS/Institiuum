import json
import os

TEMPLATE_ENDPOINT = """
from fastapi import APIRouter
from pydantic import BaseModel, Field

router = APIRouter()

class {model_name}(BaseModel):
{fields}

@router.{method_lower}("{path}")
async def handle_{model_var}(payload: {model_name}):
    print("📥 Reçu:", payload)
    return {{ "status": "✅ success", "data": payload }}
"""

def zod_type_to_pydantic(field):
    type_map = {
        "text": "str",
        "textarea": "str",
        "number": "float",
        "checkbox": "bool",
        "select": "str",
        "datepicker": "str",
        "file": "str"
    }
    f_type = type_map.get(field["type"], "str")
    return f"    {field['name']}: {f_type}"

def generate_endpoint(config_path, output_dir):
    with open(config_path) as f:
        config = json.load(f)

    model_name = config["title"].replace(" ", "").replace("-", "")
    model_var = model_name.lower()
    path = config["submitUrl"]
    method = config.get("submitMethod", "POST").upper()

    fields = "\n".join([zod_type_to_pydantic(field) for field in config["fields"]])
    endpoint_code = TEMPLATE_ENDPOINT.format(
        model_name=model_name,
        model_var=model_var,
        path=path,
        method_lower=method.lower(),
        fields=fields
    )

    safe_name = model_var.replace("/", "_")
    filename = os.path.join(output_dir, f"{safe_name}_route.py")
    with open(filename, "w") as f:
        f.write(endpoint_code)
    print(f"✅ Endpoint généré : {filename}")

def main():
    config_dir = "apps/admin/src/config"
    output_dir = "apps/api/routes/generated"
    os.makedirs(output_dir, exist_ok=True)

    for file in os.listdir(config_dir):
        if file.endswith(".config.json"):
            generate_endpoint(os.path.join(config_dir, file), output_dir)

if __name__ == "__main__":
    main()

