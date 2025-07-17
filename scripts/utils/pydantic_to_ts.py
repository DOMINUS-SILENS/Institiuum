# pydantic_to_ts.py
import sys
import importlib.util
import inspect
from pydantic import BaseModel

def pytype_to_tstype(py_type):
    mapping = {
        "str": "string",
        "int": "number",
        "float": "number",
        "bool": "boolean",
        "datetime": "string",
    }
    return mapping.get(py_type.__name__, "any")

def generate_ts(model):
    lines = [f"export interface {model.__name__} {{"]
    for name, field in model.__fields__.items():
        ts_type = pytype_to_tstype(field.outer_type_)
        optional = "?" if not field.required else ""
        lines.append(f"  {name}{optional}: {ts_type};")
    lines.append("}")
    return "\n".join(lines)

def main(filepath):
    spec = importlib.util.spec_from_file_location("model", filepath)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    models = [cls for name, cls in inspect.getmembers(module, inspect.isclass)
              if issubclass(cls, BaseModel) and cls.__module__ == "model"]

    for model in models:
        print(generate_ts(model))

if __name__ == "__main__":
    main(sys.argv[1])

