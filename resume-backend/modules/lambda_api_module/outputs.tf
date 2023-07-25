
output "lambda_role_output" {
  value = aws_iam_role.lambda_role.name
  
}

output "lambda_role_arn_output" {
  value = aws_iam_role.lambda_role.arn
  
}

output "invoke_arn" {
  value = aws_api_gateway_deployment.apigw_deployment.invoke_url
  
}

output "stage_name" {
  value = aws_api_gateway_stage.apigw_stage.stage_name
  
}

output "path_part" {
  value = aws_api_gateway_resource.visitors.path_part
  
}

output "complete_unvoke_url" {
  value = "${aws_api_gateway_deployment.apigw_deployment.invoke_url}${aws_api_gateway_stage.apigw_stage.stage_name}/${aws_api_gateway_resource.visitors.path_part}"
  
}