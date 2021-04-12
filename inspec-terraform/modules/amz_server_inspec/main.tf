# ---------------------------------------------------------------------------------------------------------------------
# module: amz_server

# Places a restraint on using a specific version of terraform
terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  profile = var.aws_profile_name
  region  = var.aws_region
}

################################################################################
data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
 owners = ["amazon"]
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}
################################################################################
resource "aws_security_group" "amz_server_sg" {
  vpc_id      = data.aws_vpc.selected.id
  name        = var.security_group_name
  description = "Security Group created by Terraform plan."
  tags = {
    Name      = var.security_group_name
    Date      = formatdate("MMM DD, YYYY", timestamp())
  }
}

resource "aws_security_group_rule" "ingress_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.security_group_ingress_cidr
  security_group_id = aws_security_group.amz_server_sg.id
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.amz_server_sg.id
}

################################################################################
resource "aws_instance" "system" {

  count                       = length(var.systems)
  ami                         = data.aws_ami.amazon-linux-2.id
  subnet_id                   = data.aws_subnet.selected.id
  instance_type               = var.system_instance_type
  vpc_security_group_ids      = [aws_security_group.amz_server_sg.id]
  associate_public_ip_address = true
  user_data                   = var.system_init_user_data
  key_name                    = var.system_key_name

  root_block_device {
    volume_size = var.system_root_volume_size
  }

  tags = {
    Name      = "${var.system_name_prefix} - ${var.systems[count.index]}"
    Date      = formatdate("MMM DD, YYYY", timestamp())
  }

  provisioner "remote-exec" {
    inline = var.provisioner_exec_data
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key    = file(var.aws_local_ssh_pem_file)
    }
  }
}

resource "null_resource" "inspec_exec" {
  depends_on = [
    aws_security_group_rule.ingress_rule,
  ]
  triggers = {
    instance_ids = join(",", aws_instance.system.*.id)
  }

  provisioner "local-exec" {
    command = <<-LOCAL_INSPEC
    ssh-keyscan ${aws_instance.system[0].public_ip} >> ~/.ssh/known_hosts
    inspec exec -t ssh://ec2-user@${aws_instance.system[0].public_ip} my_profile --no-distinct-exit
    LOCAL_INSPEC
  }
}
