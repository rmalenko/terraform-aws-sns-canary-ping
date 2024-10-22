provider "aws" {
  alias                    = "aws_main"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = var.aws_region
}

