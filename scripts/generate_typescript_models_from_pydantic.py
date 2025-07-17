import os
import ast

INPUT_DIR = "apps/api/models/generated"
OUTPUT_DIR = "apps/admin/src/models"

os.makedirs(OUTPUT_DIR, exist_ok=True)

PY_TO_TS = {
    "str": "string",
    "int": "number",
    "float": "number",
    "bool": "boolean",
    "date": "string"
}

for filename in os.listdir(INPUT_DIR):
    if filename.endswith(".py"):
        path = os.path.join(INPUT_DIR, filename)
        try:
            with open(path, "r") as f:
                content = f.read()
                tree = ast.parse(content)
        except Exception as e:
            print(f"⚠️ Ignoré : {filename} (Erreur de parsing : {e})")
            continue

        for node in tree.body:
            if isinstance(node, ast.ClassDef):
                class_name = node.name
                ts_lines = [f"export interface {class_name} {{"]
                for stmt in node.body:
                    if isinstance(stmt, ast.AnnAssign) and isinstance(stmt.target, ast.Name):
                        name = stmt.target.id
                        type_name = getattr(stmt.annotation, "id", "string")
                        ts_type = PY_TO_TS.get(type_name, "string")
                        ts_lines.append(f"  {name}: {ts_type};")
                ts_lines.append("}")

                out_path = os.path.join(OUTPUT_DIR, f"{class_name}.ts")
                with open(out_path, "w") as f:
                    f.write("\n".join(ts_lines))

                print(f"✅ TypeScript model généré : {out_path}")

