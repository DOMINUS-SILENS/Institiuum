# model_to_form_json.py
import sys
import importlib.util
import inspect
import json
from pydantic import BaseModel

def extract_fields(model):
    fields = []
    for name, field in model.__fields__.items():
        fields.append({
            "name": name,
            "label": name.capitalize(),
            "type": "text",  # à améliorer dynamiquement si besoin
            "required": field.required,
        })
    return fields

def main(filepath):
    spec = importlib.util.spec_from_file_location("model", filepath)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    models = [cls for name, cls in inspect.getmembers(module, inspect.isclass)
              if issubclass(cls, BaseModel) and cls.__module__ == "model"]

    for model in models:
        config = {
            "formName": model.__name__,
            "fields": extract_fields(model)
        }
        print(json.dumps(config, indent=2))

if __name__ == "__main__":
    main(sys.argv[1])

