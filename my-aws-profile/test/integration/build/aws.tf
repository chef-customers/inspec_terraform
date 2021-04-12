terraform {
  required_version = ">= 0.14"
}

variable "aws_profile" {}
variable "aws_region" {}
variable "aws_vpc_cidr_block" {}
variable "aws_vpc_instance_tenancy" {}
variable "aws_vpc_name" {}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_vpc" "inspec_vpc" {
  cidr_block       = var.aws_vpc_cidr_block
  instance_tenancy = var.aws_vpc_instance_tenancy

  tags = {
    Name      = var.aws_vpc_name
    Date      = formatdate("MMM DD, YYYY", timestamp())
  }
}
