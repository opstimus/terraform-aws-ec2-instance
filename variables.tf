variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "Instance name | i.e api"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami" {
  type    = string
  default = "AMI ID"
}

variable "subnet_id" {
  type        = string
  description = "VPC cidr"
}

variable "enable_eip" {
  type        = bool
  description = "Enable and attach Elastic IP"
  default     = false
}

variable "user_data" {
  type        = string
  description = "Userdata"
}

variable "security_group_ids" {
  type        = list(any)
  description = "Security group ID"
  default     = []
}

variable "vpc_id" {
  description = "VPC ID needed to create security group"
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "List of security group ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}
