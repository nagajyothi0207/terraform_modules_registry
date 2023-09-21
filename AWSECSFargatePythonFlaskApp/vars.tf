
variable "vpc_id" {
  default = ""
}
variable "subnets" {
  type    = list(string)
  default = []
}
variable "image_tag" {
  default = "latest"
}

variable "application_name" {
  default = ""
}

variable "ecs_task_desired_count" {
  default = "2"
}

variable "ecs_task_cpu_size" {
  default = "256"
}

variable "ecs_task_memory_size" {
  default = "512"
}

variable "ecs_container_port" {
  default = "5000"
}

variable "ecs_host_port" {
  default = "5000"
}

variable "alb_health_check_path" {
  default = "/"
}
variable "ecs_force_new_deployment" {
  default = true
}

variable "ecs_task_assign_public_ip" {
  default = false
}

variable "alb_inbound_allowed_public_ip" {
  default = ""
}

variable "alb_sg_inbound_ports" {
  default = [80, 443]
}

variable "alb_sg_outbound_ports" {
  default = [443, 80, 5000]
}