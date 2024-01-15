#
# Set the following variables (mandatory)
#



# ScyllaDB Cloud region
variable "scylla_region" {
  description = "ScyllaDB Cloud region of the cluster"
  type        = string
  default     = "eu-west-1"
}

# SSH private key for EC2 instance access
variable "ssh_private_key" {
  description = "SSH private key location for EC2 instance access"
  type        = string
  default     = "/Users/ricardo/Downloads/ricardo-terraform.pem"
}

variable "aws_key_pair" {
  description = "Key pair name in AWS"
  type        = string
  default     = "ricardo-terraform"
}

# AWS credentials file
variable "aws_creds" {
  description = "AWS credentials location"
  type        = string
  default     = "/Users/ricardo/.aws/credentials"
}

################################################

#
# The following variables are not required to be modified to run the demo
# but you can still modify them if you want to try a different setup
#

# # Number of threads for the Cassandra stress tool
# variable "num_threads" {
#   description = "Number of threads for the Cassandra stress tool"
#   type        = string
#   default     = "128"
# }

# # Total number of operations to run
# variable "num_of_ops" {
#   description = "Total number of operations to run"
#   type        = string
#   default     = "46B"
# }

# # Throttling for the Cassandra stress tool
# variable "throttle" {
#   description = "Throttling for the Cassandra stress tool (in ops/sec)"
#   type        = string
#   default     = "100000/s "
# }

# EC2 instance type
variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "i4i.2xlarge"
}


# Environment name
variable "custom_name" {
  description = "Name for the ScyllaDB Cloud environment"
  type        = string
  default     = "Ricardo-Benchmark"
}

# Virtual Private Cloud (VPC) IP range
variable "custom_vpc" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# EC2 instance tenancy
variable "instance_tenancy" {
  description = "EC2 instance tenancy, default or dedicated"
  type        = string
  default     = "default"
}

# Amazon Machine Image (AMI) ID
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0bca3ed0b1ef2f2fa" #UBUNTU
}

# Number of ScyllaDB Cloud instances to create
variable "scylla_node_count" {
  description = "Number of ScyllaDB instances to create"
  type        = string
  default     = "3"
}

