variable "api_gw_path_var" { 
    type        = string  
    default     = "{wapi+}"
    }

resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "example-api"
  description = "Example API Gateway for Lambda function"
  endpoint_configuration {
  types = ["REGIONAL"] 
  }
}

resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = var.api_gw_path_var
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.MyDemoResource.id
  http_method             = aws_api_gateway_method.MyDemoMethod.http_method
  integration_http_method = "POST"  # Set the integration HTTP method to POST for Lambda proxy integration
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}


resource "aws_lambda_permission" "example_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/*/*/*"
}


resource "aws_api_gateway_deployment" "MyDemoAPIDeployment" {
  depends_on    = [aws_api_gateway_integration.MyDemoIntegration, aws_api_gateway_integration_response.MyDemoIntegrationResponse]
  #depends_on    = [aws_api_gateway_integration.MyDemoIntegration]
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name    = "prod"
}


output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.MyDemoAPIDeployment.invoke_url
}