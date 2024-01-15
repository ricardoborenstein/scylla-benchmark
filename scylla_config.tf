# Fetch existing ScyllaDB instances based on the custom_name tag
data "aws_instances" "scylladb" {
  instance_tags = {
    "Name" = "${var.custom_name}-ScyllaDBInstance*" # Modify this based on your tagging convention
  }
}

output "scylladb_instance_public_ips" {
  description = "Public IPs of ScyllaDB instances"
  value       = aws_instance.scylladb.*.public_ip
}



