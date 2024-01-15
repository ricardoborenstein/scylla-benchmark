provider "aws" {
  region                   = var.scylla_region
  shared_credentials_files = ["${var.aws_creds}"]
  profile                  = "DevOpsAccessRole"
}