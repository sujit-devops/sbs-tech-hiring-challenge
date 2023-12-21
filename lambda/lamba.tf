resource "aws_lambda_function" "modify_image_lambda" {
  function_name = "modifyImageLambda"
  handler      = "lambda_handler.lambda_handler"
  runtime      = "python3.8"
  filename     = "/Users/sujit/sbs-tech-hiring-challenge/terraform/lambda_function.zip" 
  role         = aws_iam_role.lambda_execution_role.arn
  timeout      = 10
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_lambda_permission" "allow_s3" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.modify_image_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my-static-website.arn
}
