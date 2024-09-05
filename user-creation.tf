provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "example_user" {
  name = "example-user"
  path = "/system/"
}

output "user_arn" {
  description = "The ARN of the created IAM user"
  value       = aws_iam_user.example_user.arn
}
