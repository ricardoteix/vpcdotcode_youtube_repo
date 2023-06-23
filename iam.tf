# IAM User
resource "aws_iam_user" "acesso-ec2" {
  name = "acesso-ec2"
  path = "/"

  tags = {
    tag-key = "${var.tag-base}"
  }
}

resource "aws_iam_access_key" "acesso-ec2" {
  user = aws_iam_user.acesso-ec2.name
}

locals {
  policy = {
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "terraform0"
                Effect = "Allow"
                Action = [
                    "ec2-instance-connect:SendSSHPublicKey",
                    "ec2-instance-connect:OpenTunnel",
                    "ec2-instance-connect:SendSerialConsoleSSHPublicKey"
                ]
                Resource = "*"
            },
            {
                Sid = "terraform1"
                Effect = "Allow"
                Action = [
                    "ec2:DescribeInstances",
                    "ec2:DescribeInstanceConnectEndpoints"
                ]                    
                Resource = "*"
            }
        ]
    }
}

resource "aws_iam_user_policy" "acesso-ec2-policy" {
  name = "acesso_ec2_policy"
  user = aws_iam_user.acesso-ec2.name
  policy = jsonencode(local.policy)
}