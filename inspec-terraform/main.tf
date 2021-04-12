
module "amz_server_inspec" {
  source                      = "./modules/amz_server_inspec/"
  vpc_name                    = "vpc-name-to-use"
  subnet_name                 = "subnet-name-to-use"
  systems                     = ["server01"]
  system_name_prefix          = "amz_server_inspec"
  aws_profile_name            = "my-aws-profile"
  aws_region                  = "us-west-2"
  aws_local_ssh_pem_file      = "/path/to/my/aws-ssh-key.pem"
  security_group_name         = "amz_server_inspec"
  security_group_ingress_cidr = ["0.0.0.0/0"]
  system_key_name             = "my-aws-keypair"
  provisioner_exec_data       = [
    "export CHEF_LICENSE=accept-no-persist",
    "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation",
    "chef --version",
  ]
}

output "instance_name_system" {
  description = "List of Names assigned to the instances"
  value       = module.amz_server_inspec.instance_name_system
}

output "public_ip_system" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.amz_server_inspec.public_ip_system
}
