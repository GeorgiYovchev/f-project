terraform {
  required_version = "1.6.6"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.31.1"
    }

    aws = {
      source = "hashicorp/aws"
      version = "~> 5.32.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "statebucketfproject1234"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    }
  }