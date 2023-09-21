resource "random_pet" "name" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = data.aws_ami.terraform_ami.id
  }
}



resource "aws_alb" "alb" {
  name            = "${random_pet.name.id}-alb"
  subnets         = var.public_subnet_ids
  security_groups = var.public_security_group_ids
  internal        = false
  idle_timeout    = var.idle_timeout
  tags = {
    Name = "${random_pet.name.id}-alb"
  }

}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "${random_pet.name.id}-tg"
  port     = var.svc_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  tags = {
    name = "${random_pet.name.id}-tg"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = var.target_group_path
    port                = var.target_group_port
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.alb_listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  #  depends_on   = aws_alb_target_group.alb_target_group
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = var.priority
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}


