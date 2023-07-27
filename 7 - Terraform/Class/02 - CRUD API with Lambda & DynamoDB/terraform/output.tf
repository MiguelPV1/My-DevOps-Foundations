output "arn" {
  description = "API ARN"
  value = aws_apigatewayv2_api.example.execution_arn
}

output "url" {
  description = "API Endpoint"
  value = aws_apigatewayv2_api.example.api_endpoint
}

# checkov -d .: valida todos los archivos de terraform
# terraform apply "plan.out"