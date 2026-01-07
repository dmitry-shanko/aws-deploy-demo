variable "subnet_id" {
  type        = string
  description = "Existing Subnet ID"
}

variable "security_group_id" {
  type        = string
  description = "Existing Security Group ID for EC2"
}

variable "instance_profile" {
  type        = string
  description = "Existing IAM Instance Profile name for EC2"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "elastic_ip_id" {
  type        = string
  description = "Elastic IP ID for EC2"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}
