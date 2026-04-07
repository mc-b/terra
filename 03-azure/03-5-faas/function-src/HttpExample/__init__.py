import json
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json()
    except ValueError:
        body = {}

    message = body.get("message", "dummy")

    return func.HttpResponse(
        json.dumps({
            "received": message,
            "platform": "azure-functions"
        }),
        mimetype="application/json",
        status_code=200
    )