terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "autophagy-tf"
    key    = "haefen"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

