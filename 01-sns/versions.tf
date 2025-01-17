terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.70.0"
      configuration_aliases = [aws.aws_main]
    }
  }
}
