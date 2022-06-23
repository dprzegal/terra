resource "aws_iam_role" "s3-mybucket-role-DPR" {
  name               = "s3-mybucket-role-DPR"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action: "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
  name = "s3-mybucket-role-DPR"
  role = aws_iam_role.s3-mybucket-role-DPR.name
}

resource "aws_iam_role_policy" "s3-mybucket-role-policy-DPR" {
  name = "s3-mybucket-role-policy-DPR"
  role = aws_iam_role.s3-mybucket-role-DPR.id
  policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
          {
              Effect = "Allow",
              Action = [
                "s3:*"
              ],
              Resource = [
                "arn:aws:s3:::init-data-playbook-docker-nginx-2022",
                "arn:aws:s3:::init-data-playbook-docker-nginx-2022/*"
              ]
          },
      ]
  })
}