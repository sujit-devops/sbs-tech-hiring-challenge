resource "aws_iam_role" "s3_ec2_role" {
  name = "s3-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_ec2_policy" {
  name = "s3-ec2-policy"
  role = aws_iam_role.s3_ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-static-website46551jaffsfwerdjdf",
        "arn:aws:s3:::my-static-website46551jaffsfwerdjdf/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "s3_ec2_profile" {
  name = "s3-ec2-profile"
  role = aws_iam_role.s3_ec2_role.name
}
