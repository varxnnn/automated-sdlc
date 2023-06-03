terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAQ2HYLMMRRZ4SOADB"
  secret_key = "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"
  
  # shared_config_files      = ["../config"]
  # shared_credentials_files = ["../credentials"]
  # profile                  = "default"

}