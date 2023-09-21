output "terraform_ami" {
  value = data.aws_ami.terraform_ami.id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_alb.alb.dns_name
}

output "ec2instance_public_ip" {
  value = join("", aws_instance.bastion_server[*].public_ip)
}

output "s3bucket_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}

# Output AWS IAM Service Linked Role
output "service_linked_role_arn" {
  value = aws_iam_service_linked_role.autoscaling.arn
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.autoscaling_group[0].name
}

output "iam_policy" {
  value = aws_iam_policy.policy.arn
}