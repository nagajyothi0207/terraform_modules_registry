variable "bastion_host_subnet_id" {
  default = ""
}

variable "bastion_server_provisioning" {
  description = "If set to true, it will create vm"
  type        = bool
  default     = false
}
variable "nginx_app_setup" {
  description = "If set to true, it will create vm"
  type        = bool
  default     = true
}


variable "key_name" {
  default = "CKA-cluster-key"
}

variable "target_group_name" {
  default = "Project_Govtech_TG"
}

variable "svc_port" {
  default = "80"
}

variable "target_group_sticky" {
  default = ""
}

variable "target_group_path" {
  default = "/index.html"
}

variable "target_group_port" {
  default = "80"
}

variable "alb_listener_port" {
  default = "80"
}

variable "alb_listener_protocol" {
  default = "HTTP"
}

variable "priority" {
  default = "1"
}

variable "alb_name" {
  default = "Project_Govtech_LB"
}

variable "internal_alb" {
  default = false
}

variable "idle_timeout" {
  default = 60
}

variable "alb_path" {
  default = ""
}

variable "public_subnet_ids" {
  default = ""
}

variable "private_subnet_ids" {
  default = ""
}

variable "public_security_group_ids" {
  default = ""
}
variable "private_security_group_ids" {
  default = ""
}

variable "default_vpc_id" {
  default = ""
}

variable "minimum_size_for_asg" {
  default = 3
}

variable "max_size_for_asg" {
  default = 3
}

variable "desired_size_for_asg" {
  default = 3
}