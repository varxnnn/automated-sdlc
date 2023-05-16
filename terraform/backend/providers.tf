terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
#   region = "ap-south-1"
#   access_key = var.access_key
#   secret_key = var.secret_key

  shared_config_files      = ["../config"]
  shared_credentials_files = ["../credentials"]
  profile                  = "default"

}