import json
import boto3
import os


# Initialize dynamodb boto3 object
dynamodb = boto3.resource('dynamodb')

# Set dynamodb table name variable from env
ddbTableName = 'GuestCount'
table = dynamodb.Table(ddbTableName)


def lambda_handler(event, context):
    # Update item in table or add if doesn't exist
    ddbResponse = table.update_item(
        Key={
            'VisitID': 'count'
        },
        UpdateExpression='SET visitor_count = visitor_count + :value',
        ExpressionAttributeValues={
            ':value':1
        },
        ReturnValues="UPDATED_NEW"
    )


    # Format dynamodb response into variable
    responseBody = json.dumps({"count": int(ddbResponse["Attributes"]["visitor_count"])})


    # Create api response object
    apiResponse = {
        "isBase64Encoded": False,
        "statusCode": 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
            "Content-Type": "application/json"
        },
        "body": responseBody
    }



    # Return api response object
    return apiResponse

