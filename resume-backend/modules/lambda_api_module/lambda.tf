
/* locals {
  terraform_scripts_path = "${path.module}/../scripts"
} */


##### Lambda Zip File #####
data "archive_file" "lambda_zip_file" {
  type = "zip"
  source_dir = "${path.module}/../scripts"
  output_path = "${path.module}/../scripts/lambda_function.zip"
}

##### Lambda Zip File #####
/* resource "aws_s3_object" "lambda_hello" {
  bucket = var.bucket_name

  key = "lambda_function.zip"
  source = data.archive_file.lambda_zip_file.output_path

  etag = filemd5(data.archive_file.lambda_zip_file.output_path)
} */

##### IAM Role for Lambda #####
resource "aws_iam_role" "lambda_role" {
  name = "crc-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}


##### IAM Policy for Lambda Role #####
resource "aws_iam_policy" "lambda_policy" {
  name = "crc-lambda-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/GuestCount"
        }

    ]
}
EOF
}

##### IAM Policy Attachment #####
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


##### Lambda Function #####
resource "aws_lambda_function" "lambda_function" {
  filename = "${path.module}/../scripts/lambda_function.zip"
  function_name = "crc-lambda_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  runtime = "python3.8"
  
}

##### API Gateway-Lambda Permission #####
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cloud_apigw.execution_arn}/*/*"
}