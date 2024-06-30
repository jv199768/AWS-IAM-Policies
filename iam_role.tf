resource "aws_iam_role" "forwarder" {
  name               = "log-forwarder-role"
  assume_role_policy = data.aws_iam_policy_document.forwarder_assume.json
}

data "aws_iam_policy_document" "forwarder_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.forwarder.name
}

resource "aws_iam_role_policy" "forwarder_inline_policy" {
  name = "forwarder_inline_policy"
  role = aws_iam_role.forwarder.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LogStreamsAccessAll",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "SplunkCredentialsAccess",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetResourcePolicy"
            ],
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:058264204247:secret:<third-party-api-key>"
            ]
        }
    ]
})
}

