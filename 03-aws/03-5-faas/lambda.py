import json

def lambda_handler(event, context):
    print("event:", json.dumps(event))
    print("request_id:", context.aws_request_id)

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Hallo von AWS Lambda"
        })
    }