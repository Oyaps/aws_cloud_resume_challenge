
##### Resume API Gateway #####
resource "aws_api_gateway_rest_api" "cloud_apigw" {
  name = "crc-api-gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

##### API Gateway Resource #####
resource "aws_api_gateway_resource" "visitors" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  parent_id = aws_api_gateway_rest_api.cloud_apigw.root_resource_id
  path_part = "visitors"
}

##### API Gateway Post Method #####
resource "aws_api_gateway_method" "api_post" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id   = aws_api_gateway_resource.visitors.id
  http_method   = "POST"
  authorization = "NONE"
  
}

##### API Gateway Post Integration #####
resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id             = aws_api_gateway_resource.visitors.id
  http_method             = aws_api_gateway_method.api_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}


##### API Gateway Post Method Response #####
resource "aws_api_gateway_method_response" "post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_integration.post_integration.http_method
  status_code = "200"

    response_models = {
    "application/json" = "Empty"
  }

    lifecycle {
    ignore_changes = all
  }
}

##### API Gateway Post Integration Response #####
resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_method_response.post_response_200.http_method
  status_code = aws_api_gateway_method_response.post_response_200.status_code

  response_templates = {
    "application/json" = ""
  }
}



##### API Gateway Get Method #####
resource "aws_api_gateway_method" "api_get" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id   = aws_api_gateway_resource.visitors.id
  http_method   = "GET"
  authorization = "NONE"
  
}

##### API Gateway Get Integration #####
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id             = aws_api_gateway_resource.visitors.id
  http_method             = aws_api_gateway_method.api_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

##### API Gateway Get Method Response #####
resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_integration.get_integration.http_method
  status_code = "200"

    response_models = {
    "application/json" = "Empty"
  }

    lifecycle {
    ignore_changes = all
  }
}

##### API Gateway Get Integration Response #####
resource "aws_api_gateway_integration_response" "get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_method_response.get_response_200.http_method
  status_code = aws_api_gateway_method_response.get_response_200.status_code

  response_templates = {
    "application/json" = ""
  }
}

##### API Gateway Deployment #####
resource "aws_api_gateway_deployment" "apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.cloud_apigw.body))
  }

  /* depends_on = [
    aws_api_gateway_integration.post_integration
  ] */

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw_stage" {
  deployment_id = aws_api_gateway_deployment.apigw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.cloud_apigw.id
  stage_name    = "Prod"
}










/* resource "aws_api_gateway_model" "api_model" {
  rest_api_id  = aws_api_gateway_rest_api.cloud_apigw.id
  name         = "user"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title" : "Empty Schema",
  "type" : "object"
}
EOF
} */

/* ##### API Gateway Options Method #####
resource "aws_api_gateway_method" "api_options" {
  rest_api_id = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id   = aws_api_gateway_resource.visitors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  
}

##### API Gateway Options Integration #####
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cloud_apigw.id
  resource_id             = aws_api_gateway_resource.visitors.id
  http_method             = aws_api_gateway_method.api_options.http_method
  type                    = "MOCK"
} */