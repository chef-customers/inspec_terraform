# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_name" {
  description = "VPC name to use"
  type = string
}

variable "subnet_name" {
  description = "Subnet name to use"
  type = string
}

variable "provisioner_exec_data" {
  description = "Lines to sent to remote-exec provisioner"
  type = list(string)
  default = ["echo 'nothing to do'"]
}

variable "aws_profile_name" {
  description = "The name of the aws profile needed for intended use"
  type        = string
}

variable "aws_region" {
  description = "The name of the region in the instance will live"
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group to create/use"
  type        = string
}

variable "security_group_ingress_cidr" {
  description = "CIDR block list to be allowed ingress access to ec2 instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "system_instance_type" {
  description = "The instance type"
  type        = string
  default     = "t3.large"
}

variable "system_key_name" {
  description = "Optional name of key pair to use"
  type        = string
  default     = ""
}

variable "aws_local_ssh_pem_file" {
  description = "File path to local pem file to use for SSH authentication to EC2 instances"
  type        = string
  default     = ""
}

variable "system_init_user_data" {
  description = "User Data block to pass to instance"
  type        = string
  default     = ""
}

variable "systems" {
  description = "Name of systems"
  type        = list(string)
}

variable "system_root_volume_size" {
  type = number
  default = 8
}

variable "system_name_prefix" {
  description = "Prefix for the system name as it will be displayed in EC2."
  type = string
}

variable "system_remote_exec_commands" {
  description = "Commands to run with remote_exec after creation"
  type = string
  default = ""
}

variable "contact_tag_value" {
  description = "Contact Information"
  type        = string
}

variable "department_tag_value" {
  description = "Department Information"
  type        = string
}
