



#Create an IAM Role
resource "aws_iam_role" "bastion_server_role" {
  name                  = "${random_pet.name.id}-bastion_server-ec2_role"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_server_role.name
}

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.bastion_server_role.name
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "test_profile"
  role = aws_iam_role.bastion_server_role.name

}
/*
resource "aws_iam_policy" "bucket_policy" {
  name        = "${random_pet.name.id}-bucket-iam-policy"
  path        = "/"
  description = "Allow "
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_policy" {
  role       = aws_iam_role.bastion_server_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}
*/
resource "aws_iam_policy" "policy" {
  name        = "${random_pet.name.id}-iam-policy"
  path        = "/"
  description = "Allow "
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:CreateOrUpdateTags",
        "autoscaling:AttachLoadBalancerTargetGroups",
        "autoscaling:DetachLoadBalancerTargetGroups"
      ],
      "Resource" : [
        aws_autoscaling_group.autoscaling_group[0].arn,
        aws_alb_target_group.alb_target_group.arn
      ],
      },
      {
        "Effect" : "Allow",
        "Action" : "autoscaling:Describe*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateServiceLinkedRole",
          "iam:PassRole",
        ]
        "Resource" : "arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
        "Condition" : {
          "StringEquals" : { "iam:PassedToService" : ["autoscaling.amazonaws.com"] },
          "StringLike" : { "iam:AWSServiceName" : "autoscaling.amazonaws.com" }
        }
      },
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListKeys",
          "kms:ListAliases"
        ],
        "Resource" : "arn:aws:kms:*:${local.account_id}:key/*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "asg_policy" {
  role       = aws_iam_role.bastion_server_role.name
  policy_arn = aws_iam_policy.policy.arn
}


# AWS IAM Service Linked Role for Autoscaling Group
resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "autscaling-service-role"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

