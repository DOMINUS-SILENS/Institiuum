# form_json_to_fastapi_route.py
import sys
import json
import os

def main(filepath):
    with open(filepath, "r") as f:
        config = json.load(f)

    form_name = config.get("formName", "Form")
    route_name = form_name.lower()

    print(f"""from fastapi import APIRouter

router = APIRouter()

@router.post("/{route_name}/submit")
def submit_{route_name}(data: dict):
    return {{"message": "Data received for {form_name}", "data": data}}
""")

if __name__ == "__main__":
    main(sys.argv[1])

