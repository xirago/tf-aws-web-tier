terraform {
  required_version = "~> 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
