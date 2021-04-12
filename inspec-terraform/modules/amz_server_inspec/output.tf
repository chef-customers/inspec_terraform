output "instance_name_system" {
  description = "List of Names assigned to the instances"
  value       = aws_instance.system.*.tags.Name
}

output "public_ip_system" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.system.*.public_ip
}
