# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/greet_lambda.py"
  output_path = "${path.module}/greet_lambda.zip"
}

resource "aws_lambda_function" "greet_lambda" {
  function_name    = "GreetLambda"
  runtime         = "python3.10"
  role           = aws_iam_role.lambda_role.arn
  handler        = "greet_lambda.lambda_handler"
  filename       = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

resource "aws_vpc" "lambda_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "lambda_subnet" {
  vpc_id = aws_vpc.lambda_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}