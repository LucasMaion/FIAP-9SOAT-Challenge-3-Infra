terraform {
  required_version = "~> 1.6"

  backend "s3" {
    key    = "app_infra.tfstate"
    region = "us-east-1"
  }
}
