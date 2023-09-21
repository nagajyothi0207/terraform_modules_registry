

resource "aws_instance" "bastion_server" {
  count                  = var.bastion_server_provisioning ? 1 : 0
  ami                    = data.aws_ami.terraform_ami.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = var.bastion_host_subnet_id
  vpc_security_group_ids = var.public_security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.iam_profile.name
  root_block_device {
    delete_on_termination = false
    volume_size           = 50
    volume_type           = "gp3"
  }
  tags = {
    Name = "Bastion_Server"
  }
}


resource "aws_launch_configuration" "asg_launch_configuration" {
  count                = var.nginx_app_setup ? 1 : 0
  name_prefix          = "${random_pet.name.id}-asg-launch-config"
  image_id             = data.aws_ami.terraform_ami.id
  instance_type        = "t2.micro"
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.iam_profile.name
  security_groups      = var.private_security_group_ids
  user_data            = <<-EOF
		#! /bin/bash
    sudo yum update -y
    sudo yum install -y amazon-linux-extras
    sudo amazon-linux-extras install nginx1 -y
    sudo systemctl enable nginx.service
    sudo sleep 60
    sudo aws --region ${local.region} s3 cp s3://${aws_s3_bucket.s3_bucket.id}/index.html /usr/share/nginx/html/index.html
    sudo aws --region ${local.region} s3 cp s3://${aws_s3_bucket.s3_bucket.id}/styles.css /usr/share/nginx/html/styles.css
    sudo aws --region ${local.region} s3 cp s3://${aws_s3_bucket.s3_bucket.id}/function.js /usr/share/nginx/html/function.js
    sudo chmod 0755 /usr/share/nginx/html/index.html
    sudo chmod 0755 /usr/share/nginx/html/styles.css
    sudo chmod 0755 /usr/share/nginx/html/function.js
    sudo systemctl start nginx.service

	EOF
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_s3_bucket.s3_bucket,
    aws_s3_object.objects
  ]
}



resource "aws_autoscaling_group" "autoscaling_group" {
  count                = var.nginx_app_setup ? 1 : 0
  name                 = "${random_pet.name.id}-asg"
  min_size             = var.minimum_size_for_asg
  max_size             = var.max_size_for_asg
  desired_capacity     = var.desired_size_for_asg
  launch_configuration = aws_launch_configuration.asg_launch_configuration[0].name
  vpc_zone_identifier  = var.private_subnet_ids
  target_group_arns    = [aws_alb_target_group.alb_target_group.id]
  depends_on = [
    aws_launch_configuration.asg_launch_configuration,
    aws_s3_bucket.s3_bucket,
    aws_s3_object.objects
  ]
}



