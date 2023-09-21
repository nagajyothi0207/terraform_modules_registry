variable "myip" {
  description = "The public IP of your trusted network to access the Bastion Server"
  default     = ""
}
variable "vpc_cidr" {
  description = "cidr block for VPC creation, e.g 172.31.0.0/16"
  default     = ""
}
variable "application_name" {
  default = "monitoring-app"
}
