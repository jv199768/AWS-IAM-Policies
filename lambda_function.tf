resource "aws_lambda_function" "log_forwarder" {
  function_name = "log-forwarder"
  role          = aws_iam_role.forwarder.arn // <--- OUR ROLE
  runtime       = "nodejs16.x"
  handler       = "log-forwarder.handler"
    filename = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}


