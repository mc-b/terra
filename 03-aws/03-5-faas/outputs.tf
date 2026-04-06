

output "url" {
  value = aws_apigatewayv2_stage.hello.invoke_url
}

output "function_name" {
  value = aws_lambda_function.hello.function_name
}